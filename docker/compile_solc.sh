#!/bin/sh
SOLC_RAW=$1
SOLC_COMPILED=$(echo $1 | sed "s/sol/json/")
solc --evm-version byzantium --combined-json abi,bin,compact-format $SOLC_RAW > compiled/$SOLC_COMPILED

# follow below contract.sol
# // SPDX-License-Identifier: UNLICENSED
# pragma solidity ^0.8.0;

# contract XXXXX {
# }
