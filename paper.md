---
title: WiredTiger Backend for OpenLDAP
company: Open Source Solution Technology Corporation
author: HAMANO Tsukasa \<hamano@osstech.co.jp\>
date: \today
abstract:
 This paper introduces WiredTiger backend for OpenLDAP.
 WiredTiger is an embeded database having the characteristics of multi-core scalability and lock-free algorithms.
 We implemented a new OpenLDAP backend called back-wt that using WiredTiger database and then we measured the performance.

---

# Motivation
BerkeleyDB is a legacy embeded database.
The write performance of back-bdb(OpenLDAP backend using BerkeleyDB) is painfully slow and not scalabile.
If we use asynchronous mode in order to improve the write performance, data durability will be sacrificed.
The WiredTiger backend will bring about high write performance and high concurrency performance for OpenLDAP.

# Data Structure
First, we had to choose data structure either plain structure such as back-bdb or hierarchical structure such as back-hdb.
If we choose the plain structure, sub scope search is fast but modrdn and add operations need some cost.
The plain structure need many `@prefix` entry for sub scope search, and also `%prefix` entries are needed.
If we choose the hierarchical structure, modrdn is fast but lookup and add operations need some cost.

![Plain structure vs Hierarchical structure](figure/plain_vs_hierarchical.eps)

We followed basically plain data structure but we made some enhancements to the data structure for perfomance and footprint.
Before adding an entry, we reversed the DN per RDN and then added the `Reverse DN` as the key *into/to?* WiredTiger's B-Tree table.
At this point, entries are sorted by `Reverse DN`, So we can search rapidly with a sub scope using WiredTiger's range search.
The range search method is low cost that only needs `WT_CURSOR::search_near()` and increment cursor operations for this purpose.

![Making Reverse DN](figure/reverse_dn.eps)

![back-wt data structure](figure/back-wt_data_structure.eps)

# Current Status

 * slapadd, slapcat, slapindex have been implemented.
 * LDAP BIND, ADD, DELETE, SEARCH have been implemented.
 * MODIFY, MODRDN have been not implement yet.
 * deref search have not implement yet.
 * WiredTiger does not support multiprocess access yet.
 It means that we can't to do slapcat while running slapd at the moment.
 However, WiredTiger is planning to support RPC in the future.
 If it is realized, We can do hot-backup while to avoid multi-process locking.
 * back-wt does not implement entry cache similar to back-bdb.
 It's not absolutely necessary sine WiredTiger cache is fast enough.

# Benchmarking
We have measured benchmarks that focus on concurrency performance.
We use benchmarking tool called lb.[^lb] See our wiki page for detail of benchmarks.[^benchmark_result]
[^lb]: <https://github.com/hamano/lb>
[^benchmark_result]: <https://github.com/osstech-jp/openldap/wiki/back_wt-benchmark>

![LDAP ADD Benchmarking (This graph is not broken)](benchmark/add.eps)

![LDAP BIND Benchmarking](benchmark/bind.eps)

![LDAP SEARCH Benchmarking](benchmark/search.eps)

## Analysis
 * We used 24-core CPU.
