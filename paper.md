---
title: WiredTiger Backend for OpenLDAP
company: Open Source Solution Technology Corporation
author: HAMANO Tsukasa \<hamano@osstech.co.jp\>
date: \today
abstract:
 This paper introduce WiredTiger Backend for OpenLDAP.
 WiredTiger is embeded database having the characteristics of multi-core scalability and lock-free algorithms.
 We implemented a new OpenLDAP backend that using WiredTiger database and then we made an experiment about performance.

---

# Motivation
BerkeleyDB is legacy embeded database.
The Writing performance of back-bdb(OpenLDAP backend using BerkeleyDB) is painful slow and low scalability.
If using asynchronous mode in order to improve the write performance, safety will be sacrificed.
The WiredTiger backend will bring about high write performance and high concurrency performance for OpenLDAP.

# Data Structure
First, We had to choice data structure either plain structure such as back-bdb or hierarchical structure such as back-hdb.
If we choice a plain structure, sub scope search are fast but modrdn and add operations need some cost.
If we choice a hierarchical structure, modrdn is fast but lookup and add operations need some cost.

![Plain structure vs Hierarchical structure](figure/plain_vs_hierarchical.eps)

We followed basically plain data structure but we implemented some improvements to data structure for perfomance.
In back-wt, making `Reverse DN` that reversed DN per RDN when adding entry.
Then adding the `Reverse DN` as key into WiredTiger database table.
At this point, database is sorted by 'Reverse DN', So we can rapid search with sub scope using wiredtiger's range search.

![Making Reverse DN](figure/reverse_dn.eps)

![back-wt data structure](figure/back-wt_data_structure.eps)

# Current Status

 * slapadd, slapcat, slapindex will works
 * LDAP BIND, ADD, DELETE, SEARCH will works.
 * MODIFY, MODRDN does not implement yet.
 * deref search does not implement yet.
 * WiredTiger does not support multiprocess access yet.
 It mean that we can't to do slatcat while running slapd. It will be supported in the future.
 * back-wt does not implement entry cache such as back-bdb.
 It's not absolutely necessary due to WiredTiger cache is fast enough.

# Benchmarking
We use benchmarking tool called lb[^lb]

![LDAP ADD Benchmarking](benchmark/add.eps)

![LDAP BIND Benchmarking](benchmark/bind.eps)

![LDAP SEARCH Benchmarking](benchmark/search.eps)

[^lb]: <https://github.com/hamano/lb>
