# Custody-Transfer-using-Hyperledger-Fabric
 
Go to the Test_Network directory:

  ./network.sh down \n
  ./network.sh up createChannel \n
  docker run -i -t -d -p 9051 hyperledger/fabric-peer:latest \n
  docker run -i -t -d -p 13051 hyperledger/fabric-peer:latest \n
  ./network.sh deployCC -ccn basic -ccp ../Custody-Transfer-using-Hyperledger-Fabric/ct-chaincode-js/ -ccl javascript -cci InitLedger \n
