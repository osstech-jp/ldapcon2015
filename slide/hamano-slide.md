---
title: WiredTiger Backend for OpenLDAP
institute: Open Source Solution Technology Corporation
author: Tsukasa Hamano \<hamano@osstech.co.jp\>
date: LDAPCon 2015 Edinburgh November 2015
theme: osstech
---
# About me

# About WiredTiger

- Embedded database
- High performance
- High scalable

\bg{images/tiger1.jpg}

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

\Huge{54/65}

# Tasks

- Hot-backup
- alias and glue entry

# Questions?

\bg{images/tiger2.jpg}

