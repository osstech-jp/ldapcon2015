---
title: WiredTiger Backend for OpenLDAP
institute: Open Source Solution Technology Corporation
author: Tsukasa Hamano \<hamano@osstech.co.jp\>
date: LDAPCon 2015 Edinburgh November 2015
theme: osstech
---
# About OSSTech

\vskip -2em

- ID Management leading company in Japan.
- Storage Solution
- Open Source Contribution

\bg{images/tokyo.pdf}

# What's back-wt

\bg{images/openldap.jpg}

- New OpenLDAP Backend
- WiredTiger Database

# About WiredTiger

- Embedded database
- High performance
- High scalability

\bg{images/tiger1.jpg}

# Lock Free
\bg{images/padlock.jpg}

- Hazard pointer
- Optimistic concurrency control

# Data Structure
\bg{../figure/back-wt_data_structure.eps}

# bdb_next_id()
~~~
int bdb_next_id( BackendDB *be, ID *out )
{
  struct bdb_info *bdb=(struct bdb_info*)be->be_private;
  ldap_pvt_thread_mutex_lock(&bdb->bi_lastid_mutex);
  *out = ++bdb->bi_lastid;
  ldap_pvt_thread_mutex_unlock(&bdb->bi_lastid_mutex);
  return 0;
}
~~~

# wt_next_id()

~~~
int wt_next_id(BackendDB *be, ID *out){
  struct wt_info *wi = (struct wt_info *)be->be_private;
  *out = __sync_add_and_fetch(&wi->wi_lastid, 1);
  return 0;
}
~~~

# fsync(2) is slow
\bg{images/harddisk.jpg}

# Durability Level

- in-memory txn log -- fastest but no durability
- write txn log file, no sync
- write txn log file, sync per every commit

# New Benchmark Tool - lb
\bg{images/slamd.pdf}

- SLAMD is dead
- Command line interface
- Written in Go

# Installation of lb
\bg{images/gopher.pdf}

$ export GOPATH=\textasciitilde/go

$ go get github.com/hamano/lb


# Benchmark Environment

- 12 Core CPU
- No RAID Card
- SAS Disk

# BIND Benchmark Script

~~~
for c in 1 2 4 8 16 32 64 128 256 512; do
  lb bind -c $c -n 100000 \
    -D "cn=user%d,dc=example,dc=com" -w secret \
    --last 10000 ldap://targethost/
done
~~~

# BIND Benchmark Result
\fg{../benchmark/bind.eps}

# SEARCH Benchmark Script

~~~
for c in 1 2 4 8 16 32 64 128 256 512; do
  lb search -c $c -n 100000 \
    -a "(cn=user%d)" \
    --last 10000 ldap://targethost/
done
~~~

# SEARCH Benchmark Result
\fg{../benchmark/search.eps}

# ADD Benchmark Script

~~~
for c in 1 2 4 8 16 32 64 128 256 512; do
    lb add -c $c -n 10000 --uuid ldap://targethost/
done
~~~

# ADD (nosync) Benchmarks
\fg{../benchmark/add_nosync.eps}

# ADD (sync) Benchmarks
\fg{../benchmark/add_sync.eps}

# Tests

$ make -C tests wt

\Huge{$\frac{54}{65}$}
\Large{Succeed}

# Tasks

- Hot-backup
- alias and glue entry

# Thank You!

\bg{images/tiger2.jpg}

