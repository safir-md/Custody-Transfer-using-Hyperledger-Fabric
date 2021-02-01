#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/buyer1.example.com/tlsca/tlsca.buyer1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/buyer1.example.com/ca/ca.buyer1.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/buyer1.example.com/connection-buyer1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/buyer1.example.com/connection-buyer1.yaml

ORG=2
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/gov1.example.com/tlsca/tlsca.gov1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/gov1.example.com/ca/ca.gov1.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gov1.example.com/connection-gov1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gov1.example.com/connection-gov1.yaml

ORG=4
P0PORT=11051
CAPORT=9054
PEERPEM=organizations/peerOrganizations/gov2.example.com/tlsca/tlsca.gov2.example.com-cert.pem
CAPEM=organizations/peerOrganizations/gov2.example.com/ca/ca.gov2.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gov2.example.com/connection-gov2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/gov2.example.com/connection-gov2.yaml

ORG=5
P0PORT=13051
CAPORT=10054
PEERPEM=organizations/peerOrganizations/tsp1.example.com/tlsca/tlsca.tsp1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/tsp1.example.com/ca/ca.tsp1.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tsp1.example.com/connection-tsp1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/tsp1.example.com/connection-tsp1.yaml

ORG=6
P0PORT=15051
CAPORT=11054
PEERPEM=organizations/peerOrganizations/seller1.example.com/tlsca/tlsca.seller1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/seller1.example.com/ca/ca.seller1.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/seller1.example.com/connection-seller1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/seller1.example.com/connection-seller1.yaml

