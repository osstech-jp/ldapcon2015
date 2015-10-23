---
title: WiredTiger Backend for OpenLDAP
institute: Open Source Solution Technology Corporation
author: Tsukasa Hamano \<hamano@osstech.co.jp\>
date: LDAPCon 2015 Edinburgh November 2015
theme: osstech
---
# About OSSTech

- ID Management
- Storage Solution
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
    struct bdb_info *bdb = (struct bdb_info *)be->be_private;
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

- SLAMD is dead
- Command line interface
- Written by Go

\bg{images/gopher.pdf}

# Installation of lb

$ export GOPATH=\textasciitilde/go

$ go get github.com/hamano/lb

# Usage of lb

$ lb -c concurrency -n requests

# Benchmark Environment

- 12 Core CPU
- No RAID Card
- SAS Disk

# BIND Benchmark Script

~~~
for c in 1 2 4 8 16 32 64 128 256 512; do
  lb bind -c $c -n 100000 \
    -D "cn=user%d,dc=example,dc=com" -w secret
    --last 10000 $URL
done
~~~

# BIND Benchmark Result
\fg{../benchmark/bind.eps}

# SEARCH Benchmark Script

~~~
for c in 1 2 4 8 16 32 64 128 256 512; do
  lb search -c $c -n 100000 \
    -a "(cn=user%d)" \
    --last 10000 $URL
done
~~~

# SEARCH Benchmark Result
\fg{../benchmark/search.eps}

# Add Benchmark Script

~~~
for c in 1 2 4 8 16 32 64 128 256 512; do
    lb add -c $c -n 10000 --uuid $URL
done
~~~

# ADD (sync) Benchmarking

\fg{../benchmark/add_sync.eps}

# ADD (nosync) Benchmarking
\fg{../benchmark/add_nosync.eps}

# Tests

$ make -C tests wt

\Huge{$\frac{54}{65}$}
\Large{Succeed}

# Tasks

- Hot-backup
- alias and glue entry

# Questions?

\bg{images/tiger2.jpg}

