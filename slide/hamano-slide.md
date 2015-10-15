---
title: WiredTiger Backend for OpenLDAP
institute: Open Source Solution Technology Corporation
author: Tsukasa Hamano \<hamano@osstech.co.jp\>
date: LDAPCon 2015 Edinburgh November 2015
theme: osstech
---
# About OSSTech

- ID Management
- Open Source Contribution

\bg{images/osstech.jpg}

# About WiredTiger

- Embedded database
- High performance
- High scalable

\bg{images/tiger1.jpg}

# About back-wt

\bg{images/openldap.jpg}

# Lock Free

# bdb_next_id()
~~~
int bdb_next_id( BackendDB *be, ID *out )
{
    struct bdb_info *bdb = (struct bdb_info *) be->be_private;
    ldap_pvt_thread_mutex_lock( &bdb->bi_lastid_mutex );
    *out = ++bdb->bi_lastid;
    ldap_pvt_thread_mutex_unlock( &bdb->bi_lastid_mutex );
    return 0;
}
~~~

# wt_next_id()

~~~
int wt_next_id(BackendDB *be, ID *out){
    struct wt_info *wi = (struct wt_info *) be->be_private;
    *out = __sync_add_and_fetch(&wi->wi_lastid, 1);
    return 0;
}
~~~

# fsync(2) is slow

- Group commit

# Durability Level

- in-memory txn log -- fastest but no durability
- write txn log file, no sync
- write txn log file, sync per every commit

# New Benchmark Tool - lb

- slamd is dead
- Apache Bench like inteface
- Written by golang

\bg{images/gopher.pdf}

# lb

- $ go get github.com/hamano/lb
- $ lb -c concurrency -n requests
  Apache Bench like interface

# ADD (sync) Benchmarking

\fg{../benchmark/add_sync.eps}

# ADD (nosync) Benchmarking
\fg{../benchmark/add_nosync.eps}

# BIND Benchmarking
\fg{../benchmark/bind.eps}

# SEARCH Benchmarking
\fg{../benchmark/search.eps}

# Tests

$ make -C tests wt

\Huge{$\frac{54}{65}$}
\Large{Succeed}

# Tasks

- Hot-backup
- alias and glue entry

# Questions?

\bg{images/tiger2.jpg}

