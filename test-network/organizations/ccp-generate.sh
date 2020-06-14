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
        -e "s#\${P1PORT}/$6/" \
        -e "s#\${P2PORT}/$7/" \
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
        -e "s#\${P1PORT}/$6/" \
        -e "s#\${P2PORT}/$7/" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=1
P0PORT=7051
P1PORT=7151
P2PORT=7251
CAPORT=7054
PEERPEM=organizations/peerOrganizations/org1.edge.com/tlsca/tlsca.org1.edge.com-cert.pem
CAPEM=organizations/peerOrganizations/org1.edge.com/ca/ca.org1.edge.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT $P2PORT)" > organizations/peerOrganizations/org1.edge.com/connection-org1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT $P2PORT)" > organizations/peerOrganizations/org1.edge.com/connection-org1.yaml

ORG=2
P0PORT=9051
P1PORT=9151
P2PORT=9251
CAPORT=8054
PEERPEM=organizations/peerOrganizations/org2.edge.com/tlsca/tlsca.org2.edge.com-cert.pem
CAPEM=organizations/peerOrganizations/org2.edge.com/ca/ca.org2.edge.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT $P2PORT)" > organizations/peerOrganizations/org2.edge.com/connection-org2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT $P2PORT)" > organizations/peerOrganizations/org2.edge.com/connection-org2.yaml
