---
title: WiredTiger Backend for OpenLDAP
institute: Open Source Solution Technology Corporation
author: HAMANO Tsukasa \<hamano@osstech.co.jp\>
date: LDAPCon 2015 Edinburgh November 2015
keywords: OpenLDAP,WiredTiger,OSSTech,LDAPCon
abstract:
 This paper introduces WiredTiger backend for OpenLDAP.
 WiredTiger is an embedded database having characteristics of multi-core scalability and lock-free algorithms.
 We implemented a new OpenLDAP backend called back-wt that is using WiredTiger database and then measured the performance.

---

# Motivation
BerkeleyDB is a legacy embedded database.
The write performance of back-bdb (OpenLDAP backend using BerkeleyDB) is painfully slow and not scalable.
If we flush disk asynchronously in order to improve the write performance, data durability will be sacrificed.
Although OpenLDAP is a multi-threaded application, the existing backends don't scale well with number of CPUs.
The WiredTiger backend will bring about highly concurrent write performance.

# Data Structure
First, we had to choose data structure either plain structure such as back-bdb or hierarchical structure such as back-hdb.
If we choose the plain structure, sub scope searching is fast but modrdn and add operations need extra cost. Actually we can't use modrdn with sub directories on back-bdb.
The plain structure need many `@` prefix entries for sub scope searching, and also `%` prefix entries are needed for one scope searching.
If we choose the hierarchical structure, modrdn is fast but lookup and sub scope search need extra cost.

![Plain structure vs Hierarchical structure](../figure/plain_vs_hierarchical.eps)

We followed basically plain data structure but we made some enhancements to the data structure for performance and database footprint.
Before adding an entry, we reversed the DN per RDN and then added the *Reverse DN* as the key into WiredTiger's B-Tree table.
At this point, entries are sorted by *Reverse DN*, so we can search rapidly with a sub scope using WiredTiger's range search.
The range search method is efficient that only needs `WT_CURSOR::search_near()` and increment cursor operations for this purpose.

![Making Reverse DN](../figure/reverse_dn.eps)

![back-wt data structure](../figure/back-wt_data_structure.eps)

# Data Durability
WiredTiger has several durability levels of transaction.
Here is the back-wt settings corresponding to each durability level.
In back-wt, we can set wtconfig patameter in order to set durability level.
This parameters are just passed to `wiredtiger_open()`.

1. Write transaction log into memory. This is the fastest, but it only ensure durability at checkpoint.

~~~ {caption="slapd.conf for in-memory transaction log"}
wtconfig log=(enabled=false)
~~~

2. Write transaction log into file, but log records aren't flushd for each commit of the transaction. This is equivalent to dbnosync in back-bdb.

~~~ {caption="slapd.conf for writing transaction log without sync"}
wtconfig log=(enabled)
wtconfig transaction_sync=(enabled=false)
~~~

3. Write transaction log into file, and log records are flushd for each commit of the transaction.

~~~ {caption="slapd.conf for writing transaction log with sync"}
wtconfig log=(enabled)
wtconfig transaction_sync=(enabled=true)
~~~

# Current Status

 * slapadd, slapcat, slapindex have been implemented.
 * basic LDAP operations (BIND, ADD, DELETE, SEARCH, MODIFY, MODRDN) have been implemented.
 * Password Modify Extended Operation (RFC 3062) works.
 * deref search has not been implemented yet.
 * alias and glue entry have not been implemented yet.
 * WiredTiger does not support multiprocess access yet.
 It means that we can't do slapcat while running slapd at the moment.
 However, WiredTiger is planning to support RPC in the future.
 If it is realized, we can do hot-backup while avoiding multi-process locking.
 * We do not implement entry cache similar to back-bdb.
 It's not absolutely necessary since WiredTiger cache is fast enough.
 * back-wt currently uses B-Tree table. We will test LSM table in the future.

# Benchmarking
We have measured benchmarks that focus on concurrency performance by new benchmarking tool that called lb.[^lb]
This benchmark tool can generate many concurrency load by *goroutines* of Go.
See our wiki page for detail of benchmarks.[^benchmark_result]

## Enviroments

We have executed benchmarks on following environments:

- 12 Core x 2 Hyper Threading = 24 Logical CPUs.
- 15,000 RPM SAS Disks, not used RAID cards.
- Database directory was placed on ext4 file system on Linux box.
- 60G Memory
- OpenLDAP of git master at Sep 2015 and applied some back-wt patches.
- No checkpoint was performed during the benchmarking.
- We measured two methods for ADD benchmarking, the first flushes disk transaction log each request and the second doesn't flush disk transaction log each request.

## Results

![LDAP ADD Rate (sync txn log)](../benchmark/add_sync.eps)

![LDAP ADD Rate (nosync txn log)](../benchmark/add_nosync.eps)

![LDAP BIND Rate](../benchmark/bind.eps)

![LDAP SEARCH Rate](../benchmark/search.eps)

[^lb]: <https://github.com/hamano/lb>
[^benchmark_result]: <https://github.com/osstech-jp/openldap/wiki/back_wt-benchmark>

## Analysis
 * We have only used 24 logical CPUs. We may get more scalability on more CPUs.
 * The reading performances are much the same.
 * The concurrency writing performances of back-wt are pretty good.
