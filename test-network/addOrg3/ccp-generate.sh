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
        ccp-template.json
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
        ccp-template.yaml | sed -e $'s/\\\\n/\\\n        /g'
}

ORG=3
P0PORT=11051
P1PORT=11151
P2PORT=11251
CAPORT=11054
PEERPEM=../organizations/peerOrganizations/org3.edge.com/tlsca/tlsca.org3.edge.com-cert.pem
CAPEM=../organizations/peerOrganizations/org3.edge.com/ca/ca.org3.edge.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT $P2PORT)" > ../organizations/peerOrganizations/org3.edge.com/connection-org3.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM $P1PORT $P2PORT)" > ../organizations/peerOrganizations/org3.edge.com/connection-org3.yaml
