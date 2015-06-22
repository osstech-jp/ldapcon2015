---
title: WiredTiger Backend for OpenLDAP
company: Open Source Solution Technology Corporation
author: HAMANO Tsukasa \<hamano@osstech.co.jp\>
date: \today
abstract:
 This paper introduce WiredTiger backend for OpenLDAP.
 WiredTiger is embeded database having the characteristics of multi-core scalability and lock-free algorithms.
 We implemented a new OpenLDAP backend that using WiredTiger database and then we made an experiment about performance.

---

# Motivation
BerkeleyDB is legacy embeded database.
The writing performance of back-bdb(OpenLDAP backend using BerkeleyDB) is painful slow and low scalability.
If using asynchronous mode in order to improve the write performance, safety will be sacrificed.
The WiredTiger backend will bring about high write performance and high concurrency performance for OpenLDAP.

# Data Structure
First, We had to choice data structure either plain structure such as back-bdb or hierarchical structure such as back-hdb.
If we choice the plain structure, sub scope search is fast but modrdn and add operations need some cost.
The plain structure need many `@prefix` entry for sub scope search, and also `%prefix` entries are needed.
If we choice the hierarchical structure, modrdn is fast but lookup and add operations need some cost.

![Plain structure vs Hierarchical structure](figure/plain_vs_hierarchical.eps)

We followed basically plain data structure but we made some enhancements to data structure for perfomance.
In back-wt, making `Reverse DN` that reversed DN per RDN when adding an entry.
Then adding the `Reverse DN` as key into WiredTiger's B-Tree table.
At this point, entries are sorted by `Reverse DN`, So we can rapid search with sub scope using WiredTiger's range search.
The range search method is low cost that only needs `WT_CURSOR::search_near()` and increment cursor operations for this purpose.

![Making Reverse DN](figure/reverse_dn.eps)

![back-wt data structure](figure/back-wt_data_structure.eps)

# Current Status

 * slapadd, slapcat, slapindex will works.
 * LDAP BIND, ADD, DELETE, SEARCH will works.
 * MODIFY, MODRDN does not implement yet.
 * deref search does not implement yet.
 * WiredTiger does not support multiprocess access yet.
 It mean that we can't to do slapcat while running slapd at the moment.
 However, WiredTiger is planning to support RPC in the future.
 If it is realized, We can do hot-backup while to avoid multi-process locking.
 * back-wt does not implement entry cache such as back-bdb.
 It's not absolutely necessary due to WiredTiger cache is fast enough.

# Benchmarking
Here is benchmarking results that noticed concurrency performance.
We use benchmarking tool called lb.[^lb] See our wiki page for detail of benchmarks.[^benchmark_result]

![LDAP ADD Benchmarking](benchmark/add.eps)

![LDAP BIND Benchmarking](benchmark/bind.eps)

![LDAP SEARCH Benchmarking](benchmark/search.eps)

[^lb]: <https://github.com/hamano/lb>
[^benchmark_result]: <https://github.com/osstech-jp/openldap/wiki/back_wt-benchmark>
