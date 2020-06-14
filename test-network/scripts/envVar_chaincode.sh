#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#

# This is a collection of bash functions used by different scripts

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/organizations/ordererOrganizations/edge.com/orderers/orderer.edge.com/msp/tlscacerts/tlsca.edge.com-cert.pem
export PEER0_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.edge.com/peers/peer0.org1.edge.com/tls/ca.crt
export PEER1_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.edge.com/peers/peer1.org1.edge.com/tls/ca.crt
export PEER2_ORG1_CA=${PWD}/organizations/peerOrganizations/org1.edge.com/peers/peer2.org1.edge.com/tls/ca.crt

export PEER0_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.edge.com/peers/peer0.org2.edge.com/tls/ca.crt
export PEER1_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.edge.com/peers/peer1.org2.edge.com/tls/ca.crt
export PEER2_ORG2_CA=${PWD}/organizations/peerOrganizations/org2.edge.com/peers/peer2.org2.edge.com/tls/ca.crt

export PEER0_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.edge.com/peers/peer0.org3.edge.com/tls/ca.crt
export PEER1_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.edge.com/peers/peer1.org3.edge.com/tls/ca.crt
export PEER2_ORG3_CA=${PWD}/organizations/peerOrganizations/org3.edge.com/peers/peer2.org3.edge.com/tls/ca.crt

# Set OrdererOrg.Admin globals
setOrdererGlobals() {
  export CORE_PEER_LOCALMSPID="OrdererMSP"
  export CORE_PEER_TLS_ROOTCERT_FILE=${PWD}/organizations/ordererOrganizations/edge.com/orderers/orderer.edge.com/msp/tlscacerts/tlsca.edge.com-cert.pem
  export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/ordererOrganizations/edge.com/users/Admin@edge.com/msp
}

# Set environment variables for the peer org  
setGlobals() {
  local USING_ORG=""
  # peer number
  local USING_PEER=$2
  if [ -z "$OVERRIDE_ORG" ]; then
    USING_ORG=$1
  else
    USING_ORG="${OVERRIDE_ORG}"
  fi
  echo "Using organization ${USING_ORG}"
  if [ $USING_ORG -eq 1 ]; then
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org1.edge.com/users/Admin@org1.edge.com/msp
    echo "Using peer ${USING_PEER}"
    if [ $USING_PEER -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
      export CORE_PEER_ADDRESS=localhost:7051
    elif [ $USING_PEER -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG1_CA
      export CORE_PEER_ADDRESS=localhost:7151
    elif [ $USING_PEER -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_ORG1_CA
      export CORE_PEER_ADDRESS=localhost:7251
    else
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
      export CORE_PEER_ADDRESS=localhost:7051
    fi
  elif [ $USING_ORG -eq 2 ]; then
    export CORE_PEER_LOCALMSPID="Org2MSP"
    export CORE_PEER_MSPCONFIGPATH=${PWD}/organizations/peerOrganizations/org2.edge.com/users/Admin@org2.edge.com/msp
    echo "Using peer ${USING_PEER}"
    if [ $USING_PEER -eq 0 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
      export CORE_PEER_ADDRESS=localhost:9051
    elif [ $USING_PEER -eq 1 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER1_ORG2_CA
      export CORE_PEER_ADDRESS=localhost:9151
    elif [ $USING_PEER -eq 2 ]; then
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER2_ORG2_CA
      export CORE_PEER_ADDRESS=localhost:9251
    else
      export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG2_CA
      export CORE_PEER_ADDRESS=localhost:9051
    fi
  else
    echo "================== ERROR !!! ORG Unknown =================="
  fi

  if [ "$VERBOSE" == "true" ]; then
    env | grep CORE
  fi
}

# parsePeerConnectionParameters $@
# Helper function that sets the peer connection parameters for a chaincode
# operation
# $1: org number
# $2: peer number
parsePeerConnectionParameters() {

  PEER_CONN_PARMS=""
  PEERS=""
  #while [ "$#" -gt 0 ]; do
  setGlobals $1 $2
  PEER="peer$2.org$1"
  ## Set peer adresses
  PEERS="$PEERS $PEER"
  PEER_CONN_PARMS="$PEER_CONN_PARMS --peerAddresses $CORE_PEER_ADDRESS"
  ## Set path to TLS certificate
  TLSINFO=$(eval echo "--tlsRootCertFiles \$PEER$2_ORG$1_CA")
  PEER_CONN_PARMS="$PEER_CONN_PARMS $TLSINFO"
    # shift by one to get to the next organization
    #shift
  #done
  # remove leading space for output
  PEERS="$(echo -e "$PEERS" | sed -e 's/^[[:space:]]*//')"
}

verifyResult() {
  if [ $1 -ne 0 ]; then
    echo "!!!!!!!!!!!!!!! "$2" !!!!!!!!!!!!!!!!"
    echo
    exit 1
  fi
}
