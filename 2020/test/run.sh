#!/usr/bin/env bash

for f in src/day*.zig
do
	echo == $f
	zig run $f 2>&1
done
