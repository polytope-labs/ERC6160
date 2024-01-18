# ERC6160
Implementation of ERC6160

This set of interfaces and contracts relates to the [Multi-Chain Native Token Standard.](https://github.com/polytope-labs/EIPs/blob/master/EIPS/eip-6160.md)

The motivation for this standard can be found from our [research publication.](https://research.polytope.technology/multi-chain-native-tokens)

The Core Interfaces specifying the standard specified in the EIP:
* {{IERC6160Ext20.sol}}
* {{IERC6160Ext721.sol}}
* {{IERC6160Ext1155.sol}}

Multi-Chain token contracts that chooses to conform to this EIP `MUST` extend their corresponding interface above. 


These example core token contracts implements the interfaces as so:
* {{ERC20.sol}}
* {{ERC721.sol}}
* {{ERC1155.sol}}

|Note | This standard is unopinionated, however, aims to set the foundation for creating multi-chain native tokens, also the specifics for authorization and access control are left for developers to implement in token contracts.|
----- | -----