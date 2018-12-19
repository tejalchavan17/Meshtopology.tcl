
set ns [new Simulator]

set nf [open out.nam w]
$ns namtrace-all $nf

#Define a 'finish' procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the trace file
    close $nf
    #Execute nam on the trace file
    exec nam out.nam &
    exit0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]


$ns duplex-link $n0 $n1 1Mb 2ms DropTail
$ns duplex-link $n0 $n2 1Mb 2ms DropTail
$ns duplex-link $n0 $n3 1Mb 2ms DropTail

$ns duplex-link $n1 $n2 1Mb 2ms DropTail
$ns duplex-link $n1 $n3 1Mb 2ms DropTail

$ns duplex-link $n2 $n3 1Mb 2ms DropTail


$ns duplex-link-op $n0 $n1 orient left-down
$ns duplex-link-op $n1 $n2 orient up-down
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n0 $n3 orient up-down
 

set tcp0 [new Agent/TCP]
set tcp2 [new Agent/TCP]
set udp0 [new Agent/UDP]

set ftp0 [new Application/FTP]
set ftp1 [new Application/FTP]
set cbr0 [new Application/Traffic/CBR]

set tcp1 [new Agent/TCPSink]
set tcp3 [new Agent/TCPSink]
set null [new Agent/Null]


$ns attach-agent $n1 $tcp0
$ns attach-agent $n3 $tcp1

$ns attach-agent $n1 $tcp2
$ns attach-agent $n2 $tcp3

$ns attach-agent $n0 $udp0
$ns attach-agent $n2 $null


$ftp0 attach-agent $tcp0
$ftp1 attach-agent $tcp2

$cbr0 attach-agent $udp0

#TCP connection
$ns connect $tcp0 $tcp1
$ns connect $tcp2 $tcp3

#UDP connection
$ns connect $udp0 $null

#Schedule events for the FTP and CBR agents
$ns at 0.5 "$ftp0 start"
$ns at 1.0 "$ftp1 start"

$ns at 1.5 "$cbr0 start"

$ns at 4.5 "$ftp0 stop"
$ns at 3.5 "$ftp1 stop"

$ns at 2.5 "$cbr0 stop"


#Call the finish procedure after 5 seconds of simulation time
$ns at 5.0 "finish"

#Run the simulation
$ns run

 


