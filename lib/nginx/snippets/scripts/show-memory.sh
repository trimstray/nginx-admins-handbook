#!/bin/sh

# Display memory usage information on FreeBSD
# This function is a shell re-writting of the perl script:
##  freebsd-memory -- List Total System Memory Usage
##  Copyright (c) 2003-2004 Ralf S. Engelschall <rse@engelschall.com>
## http://www.cyberciti.biz/files/scripts/freebsd-memory.pl.txt

#   round the physical memory size to the next power of two which is
#   reasonable for memory cards. We do this by first determining the
#   guessed memory card size under the assumption that usual computer
#   hardware has an average of a maximally eight memory cards installed
#   and those are usually of equal size.

# Strict script
set -e
set -u

mem_rounded () {
    mem_size=$1
    chip_size=1
    chip_guess=`echo "$mem_size / 8 - 1" | bc`
    while [ $chip_guess != 0 ]
        do
                chip_guess=`echo "$chip_guess / 2" | bc`
                chip_size=`echo "$chip_size * 2" | bc`
    done
    mem_round=`echo "( $mem_size / $chip_size + 1 ) * $chip_size" | bc`
    echo $mem_round
        exit 0
}

free_memory () {
        #   determine the individual known information
        #   NOTICE: forget hw.usermem, it is just (hw.physmem - vm.stats.vm.v_wire_count).
        #   NOTICE: forget vm.stats.misc.zero_page_count, it is just the subset of
        #           vm.stats.vm.v_free_count which is already pre-zeroed.
        mem_phys=`sysctl -n hw.physmem`
        set +e
        mem_hw=`mem_rounded $mem_phys`
        set -e
        sysctl_pagesize=`sysctl -n hw.pagesize`
        mem_all=`echo "\`sysctl -n vm.stats.vm.v_page_count\` \
  * $sysctl_pagesize" | bc`
        mem_wire=`echo "\`sysctl -n vm.stats.vm.v_wire_count\` \
  * $sysctl_pagesize" | bc`
        mem_active=`echo "\`sysctl -n vm.stats.vm.v_active_count\` \
  * $sysctl_pagesize" | bc`
        mem_inactive=`echo "\`sysctl -n vm.stats.vm.v_inactive_count\` \
  * $sysctl_pagesize" | bc`
        mem_cache=`echo "\`sysctl -n vm.stats.vm.v_cache_count\` \
  * $sysctl_pagesize" | bc`
        mem_free=`echo "\`sysctl -n vm.stats.vm.v_free_count\` \
  * $sysctl_pagesize" | bc`

        #   determine the individual unknown information
        mem_gap_vm=`echo "$mem_all - ( $mem_wire + $mem_active + \
  $mem_inactive + $mem_cache + $mem_free )" | bc`
        mem_gap_sys=`echo "$mem_phys - $mem_all" | bc`
        mem_gap_hw=`echo "$mem_hw - $mem_phys" | bc`

        #   determine logical summary information
        mem_total=$mem_hw
        mem_avail=`echo "$mem_inactive + $mem_cache + $mem_free" | bc`
        mem_used=`echo "$mem_total - $mem_avail" | bc`

        #   print system results
        printf "SYSTEM MEMORY INFORMATION:\n"
        printf "mem_wire:      %12d (%7dMB) [%3d%%] %s\n" $mem_wire \
  `echo "$mem_wire / ( 1024 * 1024 )" | bc` `echo "$mem_wire \
  * 100 / $mem_all" | bc` "Wired: disabled for paging out"
        printf "mem_active:  + %12d (%7dMB) [%3d%%] %s\n" $mem_active \
  `echo "$mem_active / ( 1024 * 1024 )" | bc` `echo "$mem_active \
  * 100 / $mem_all" | bc` "Active: recently referenced"
        printf "mem_inactive:+ %12d (%7dMB) [%3d%%] %s\n" $mem_inactive \
  `echo "$mem_inactive / ( 1024 * 1024 )" | bc` `echo "$mem_inactive \
  * 100 / $mem_all" | bc` "Inactive: recently not referenced"
        printf "mem_cache:   + %12d (%7dMB) [%3d%%] %s\n" $mem_cache \
  `echo "$mem_cache / ( 1024 * 1024 )" | bc` `echo "$mem_cache \
  * 100 / $mem_all" | bc` "Cached: almost avail. for allocation"
        printf "mem_free:    + %12d (%7dMB) [%3d%%] %s\n" $mem_free \
  `echo "$mem_free / ( 1024 * 1024 )" | bc` `echo "$mem_free \
  * 100 / $mem_all" | bc` "Free: fully available for allocation"
        printf "mem_gap_vm:  + %12d (%7dMB) [%3d%%] %s\n" $mem_gap_vm \
  `echo "$mem_gap_vm / ( 1024 * 1024 )" | bc` `echo "$mem_gap_vm \
  * 100 / $mem_all" | bc` "Memory gap: UNKNOWN"
        printf "______________ ____________ ___________ ______\n"
        printf "mem_all:     = %12d (%7dMB) [100%%] %s\n" $mem_all \
  `echo "$mem_all / ( 1024 * 1024 )" | bc` "Total real memory managed"
        printf "mem_gap_sys: + %12d (%7dMB)        %s\n" $mem_gap_sys \
  `echo "$mem_gap_sys / ( 1024 * 1024 )" | bc` "Memory gap: Kernel?!"
        printf "______________ ____________ ___________\n"
        printf "mem_phys:    = %12d (%7dMB)        %s\n" $mem_phys \
  `echo "$mem_phys / ( 1024 * 1024 )" | bc` "Total real memory available"
        printf "mem_gap_hw:  + %12d (%7dMB)        %s\n" $mem_gap_hw \
  `echo "$mem_gap_hw / ( 1024 * 1024 )" | bc` "Memory gap: Segment Mappings?!"
        printf "______________ ____________ ___________\n"
        printf "mem_hw:      = %12d (%7dMB)        %s\n" $mem_hw \
  `echo "$mem_hw / ( 1024 * 1024 )" | bc` "Total real memory installed"
        #   print logical results
        printf "\n"
        printf "SYSTEM MEMORY SUMMARY:\n"
        printf "mem_used:      %12d (%7dMB) [%3d%%] %s\n" $mem_used \
  `echo "$mem_used / ( 1024 * 1024 )" | bc` `echo "$mem_used \
  * 100 / $mem_total" | bc` "Logically used memory"
        printf "mem_avail:   + %12d (%7dMB) [%3d%%] %s\n" $mem_avail \
  `echo "$mem_avail / ( 1024 * 1024 )" | bc` `echo "$mem_avail \
  * 100 / $mem_total" | bc` "Logically available memory"
        printf "______________ ____________ __________ _______\n"
        printf "mem_total:   = %12d (%7dMB) [100%%] %s\n" $mem_total \
  `echo "$mem_total / ( 1024 * 1024 )" | bc` "Logically total memory"
        exit 0
}

###################
## Main function ##
###################

free_memory
