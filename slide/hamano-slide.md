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

\AddToShipoutPicture*{
  \put(54,0){
    \includegraphics[height=8cm]{images/tiger1.jpg}
  }
}

# New Benchmark Tool - lb

- slamd is dead
- Apache Bench like inteface
- Written by golang

\AddToShipoutPicture*{
  \put(-4,16){
      \includegraphics[width=\paperwidth]{images/gopher.pdf}
  }
}

# lb

- $ go get github.com/hamano/lb
- $ lb -c Concurrency -n Request Number
  Apache Bench like interface

# Questions?

\AddToShipoutPicture*{
  \put(108,17){
    \includegraphics[width=9cm]{images/tiger2.jpg}
  }
}
