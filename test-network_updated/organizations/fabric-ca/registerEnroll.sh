#!/bin/bash

source scriptUtils.sh

function createBuyer1() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/buyer1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/buyer1.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:7054 --caname ca-buyer1 --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-7054-ca-buyer1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/buyer1.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-buyer1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-buyer1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-buyer1 --id.name buyer1admin --id.secret buyer1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/buyer1.example.com/peers
  mkdir -p organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-buyer1 -M ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/msp --csr.hosts peer0.buyer1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:7054 --caname ca-buyer1 -M ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls --enrollment.profile tls --csr.hosts peer0.buyer1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/buyer1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/buyer1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/buyer1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/buyer1.example.com/tlsca/tlsca.buyer1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/buyer1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/peers/peer0.buyer1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/buyer1.example.com/ca/ca.buyer1.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/buyer1.example.com/users
  mkdir -p organizations/peerOrganizations/buyer1.example.com/users/User1@buyer1.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca-buyer1 -M ${PWD}/organizations/peerOrganizations/buyer1.example.com/users/User1@buyer1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/buyer1.example.com/users/User1@buyer1.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/buyer1.example.com/users/Admin@buyer1.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://buyer1admin:buyer1adminpw@localhost:7054 --caname ca-buyer1 -M ${PWD}/organizations/peerOrganizations/buyer1.example.com/users/Admin@buyer1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/buyer1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/buyer1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/buyer1.example.com/users/Admin@buyer1.example.com/msp/config.yaml

}

function createGov1() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/gov1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/gov1.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:8054 --caname ca-gov1 --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gov1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gov1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gov1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-8054-ca-gov1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/gov1.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-gov1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-gov1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-gov1 --id.name gov1admin --id.secret gov1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/gov1.example.com/peers
  mkdir -p organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-gov1 -M ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/msp --csr.hosts peer0.gov1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:8054 --caname ca-gov1 -M ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls --enrollment.profile tls --csr.hosts peer0.gov1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/gov1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gov1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/gov1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gov1.example.com/tlsca/tlsca.gov1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/gov1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/peers/peer0.gov1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/gov1.example.com/ca/ca.gov1.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/gov1.example.com/users
  mkdir -p organizations/peerOrganizations/gov1.example.com/users/User1@gov1.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:8054 --caname ca-gov1 -M ${PWD}/organizations/peerOrganizations/gov1.example.com/users/User1@gov1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gov1.example.com/users/User1@gov1.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/gov1.example.com/users/Admin@gov1.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gov1admin:gov1adminpw@localhost:8054 --caname ca-gov1 -M ${PWD}/organizations/peerOrganizations/gov1.example.com/users/Admin@gov1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/gov1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gov1.example.com/users/Admin@gov1.example.com/msp/config.yaml

}

function createGov2() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/gov2.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/gov2.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:9054 --caname ca-gov2 --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-gov2.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-gov2.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-gov2.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca-gov2.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/gov2.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-gov2 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-gov2 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-gov2 --id.name gov2admin --id.secret gov2adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/gov2.example.com/peers
  mkdir -p organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-gov2 -M ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/msp --csr.hosts peer0.gov2.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:9054 --caname ca-gov2 -M ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls --enrollment.profile tls --csr.hosts peer0.gov2.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/gov2.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gov2.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/gov2.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/gov2.example.com/tlsca/tlsca.gov2.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/gov2.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/peers/peer0.gov2.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/gov2.example.com/ca/ca.gov2.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/gov2.example.com/users
  mkdir -p organizations/peerOrganizations/gov2.example.com/users/User1@gov2.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:9054 --caname ca-gov2 -M ${PWD}/organizations/peerOrganizations/gov2.example.com/users/User1@gov2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gov2.example.com/users/User1@gov2.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/gov2.example.com/users/Admin@gov2.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://gov2admin:gov2adminpw@localhost:9054 --caname ca-gov2 -M ${PWD}/organizations/peerOrganizations/gov2.example.com/users/Admin@gov2.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/gov2/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/gov2.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/gov2.example.com/users/Admin@gov2.example.com/msp/config.yaml

}

function createTsp1() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/tsp1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/tsp1.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:10054 --caname ca-tsp1 --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-tsp1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-tsp1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-tsp1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-10054-ca-tsp1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/tsp1.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-tsp1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-tsp1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-tsp1 --id.name tsp1admin --id.secret tsp1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/tsp1.example.com/peers
  mkdir -p organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-tsp1 -M ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/msp --csr.hosts peer0.tsp1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:10054 --caname ca-tsp1 -M ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls --enrollment.profile tls --csr.hosts peer0.tsp1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/tsp1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tsp1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/tsp1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/tsp1.example.com/tlsca/tlsca.tsp1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/tsp1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/peers/peer0.tsp1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/tsp1.example.com/ca/ca.tsp1.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/tsp1.example.com/users
  mkdir -p organizations/peerOrganizations/tsp1.example.com/users/User1@tsp1.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:10054 --caname ca-tsp1 -M ${PWD}/organizations/peerOrganizations/tsp1.example.com/users/User1@tsp1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tsp1.example.com/users/User1@tsp1.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/tsp1.example.com/users/Admin@tsp1.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://tsp1admin:tsp1adminpw@localhost:10054 --caname ca-tsp1 -M ${PWD}/organizations/peerOrganizations/tsp1.example.com/users/Admin@tsp1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/tsp1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/tsp1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/tsp1.example.com/users/Admin@tsp1.example.com/msp/config.yaml

}

function createSeller1() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/peerOrganizations/seller1.example.com/

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/peerOrganizations/seller1.example.com/
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:11054 --caname ca-seller1 --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-seller1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-seller1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-seller1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-11054-ca-seller1.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/peerOrganizations/seller1.example.com/msp/config.yaml

  infoln "Register peer0"
  set -x
  fabric-ca-client register --caname ca-seller1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register user"
  set -x
  fabric-ca-client register --caname ca-seller1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the org admin"
  set -x
  fabric-ca-client register --caname ca-seller1 --id.name seller1admin --id.secret seller1adminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/peerOrganizations/seller1.example.com/peers
  mkdir -p organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com

  infoln "Generate the peer0 msp"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-seller1 -M ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/msp --csr.hosts peer0.seller1.example.com --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/msp/config.yaml

  infoln "Generate the peer0-tls certificates"
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@localhost:11054 --caname ca-seller1 -M ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls --enrollment.profile tls --csr.hosts peer0.seller1.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/ca.crt
  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/signcerts/* ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/server.crt
  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/keystore/* ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/peerOrganizations/seller1.example.com/msp/tlscacerts
  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/seller1.example.com/msp/tlscacerts/ca.crt

  mkdir -p ${PWD}/organizations/peerOrganizations/seller1.example.com/tlsca
  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/tls/tlscacerts/* ${PWD}/organizations/peerOrganizations/seller1.example.com/tlsca/tlsca.seller1.example.com-cert.pem

  mkdir -p ${PWD}/organizations/peerOrganizations/seller1.example.com/ca
  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/peers/peer0.seller1.example.com/msp/cacerts/* ${PWD}/organizations/peerOrganizations/seller1.example.com/ca/ca.seller1.example.com-cert.pem

  mkdir -p organizations/peerOrganizations/seller1.example.com/users
  mkdir -p organizations/peerOrganizations/seller1.example.com/users/User1@seller1.example.com

  infoln "Generate the user msp"
  set -x
  fabric-ca-client enroll -u https://user1:user1pw@localhost:11054 --caname ca-seller1 -M ${PWD}/organizations/peerOrganizations/seller1.example.com/users/User1@seller1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/seller1.example.com/users/User1@seller1.example.com/msp/config.yaml

  mkdir -p organizations/peerOrganizations/seller1.example.com/users/Admin@seller1.example.com

  infoln "Generate the org admin msp"
  set -x
  fabric-ca-client enroll -u https://seller1admin:seller1adminpw@localhost:11054 --caname ca-seller1 -M ${PWD}/organizations/peerOrganizations/seller1.example.com/users/Admin@seller1.example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/seller1/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/peerOrganizations/seller1.example.com/msp/config.yaml ${PWD}/organizations/peerOrganizations/seller1.example.com/users/Admin@seller1.example.com/msp/config.yaml

}


function createOrderer() {

  infoln "Enroll the CA admin"
  mkdir -p organizations/ordererOrganizations/example.com

  export FABRIC_CA_CLIENT_HOME=${PWD}/organizations/ordererOrganizations/example.com
  #  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
  #  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@localhost:12054 --caname ca-orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-12054-ca-orderer.pem
    OrganizationalUnitIdentifier: orderer' >${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml

  infoln "Register orderer"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  infoln "Register the orderer admin"
  set -x
  fabric-ca-client register --caname ca-orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  mkdir -p organizations/ordererOrganizations/example.com/orderers
  mkdir -p organizations/ordererOrganizations/example.com/orderers/example.com

  mkdir -p organizations/ordererOrganizations/example.com/orderers/orderer.example.com

  infoln "Generate the orderer msp"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:12054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/config.yaml

  infoln "Generate the orderer-tls certificates"
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@localhost:12054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/ca.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/signcerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.crt
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/keystore/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/server.key

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts
  cp ${PWD}/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/tls/tlscacerts/* ${PWD}/organizations/ordererOrganizations/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p organizations/ordererOrganizations/example.com/users
  mkdir -p organizations/ordererOrganizations/example.com/users/Admin@example.com

  infoln "Generate the admin msp"
  set -x
  fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@localhost:12054 --caname ca-orderer -M ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp --tls.certfiles ${PWD}/organizations/fabric-ca/ordererOrg/tls-cert.pem
  { set +x; } 2>/dev/null

  cp ${PWD}/organizations/ordererOrganizations/example.com/msp/config.yaml ${PWD}/organizations/ordererOrganizations/example.com/users/Admin@example.com/msp/config.yaml

}
