param(
    [string]$networkPrefix,
    [string]$dnsServer
)

# loop through 1 to 254 to resolve dns names for each ip
1..254 | ForEach-Object {
    $ip = "$networkPrefix.$_"
    Resolve-DnsName -DnsOnly $ip -Server $dnsServer -ErrorAction Ignore
}