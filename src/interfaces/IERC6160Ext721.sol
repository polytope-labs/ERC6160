// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.17;

import {IERC_ACL_CORE} from "./IERCAclCore.sol";

// The EIP-165 identifier of this interface is 0xcce39764
interface IERC5679Ext721 {
	function safeMint(address _to, uint256 _id, bytes calldata _data) external;
	function burn(address _from, uint256 _id, bytes calldata _data) external;
}

/**
 * @dev Interface of the ERC6160 standard, as defined in
 * https://github.com/polytope-labs/EIPs/blob/master/EIPS/eip-6160.md.
 *
 * @author Polytope Labs
 *
 * The EIP-165 identifier of this interface is 0xa75a5a72
 */
interface IERC6160Ext721 is IERC5679Ext721, IERC_ACL_CORE {}
