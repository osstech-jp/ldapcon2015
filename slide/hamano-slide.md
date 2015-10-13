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

\bg[images/tiger1.jpg]

# New Benchmark Tool - lb

- slamd is dead
- Apache Bench like inteface
- Written by golang

\bg[images/gopher.pdf]

# lb

- $ go get github.com/hamano/lb
- $ lb -c Concurrency -n Request Number
  Apache Bench like interface

# ADD (sync) Benchmarking
\includegraphics[width=0.8\paperwidth]{../benchmark/add_sync.eps}

# ADD (nosync) Benchmarking
\includegraphics[width=0.8\paperwidth]{../benchmark/add_nosync.eps}

# BIND Benchmarking
\includegraphics[width=0.8\paperwidth]{../benchmark/bind.eps}

# SEARCH Benchmarking
\includegraphics[width=0.8\paperwidth]{../benchmark/search.eps}

# Tests

$ make -C tests wt

54/65

# Tasks

- Hot-backup
- alias and glue entry

# Questions?

\AddToShipoutPicture*{
  \put(108,17){
    \includegraphics[width=9cm]{images/tiger2.jpg}
  }
}
