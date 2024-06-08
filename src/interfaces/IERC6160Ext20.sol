pragma solidity ^0.8.17;

import {IERC_ACL_CORE} from "./IERCAclCore.sol";

// The EIP-165 identifier of this interface is 0xd0017968
interface IERC5679Ext20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

/**
 * @dev Interface of the ERC6160 standard, as defined in
 * https://github.com/polytope-labs/EIPs/blob/master/EIPS/eip-6160.md.
 *
 * @author Polytope Labs
 *
 * The EIP-165 identifier of this interface is 0xbbb8b47e
 */
interface IERC6160Ext20 is IERC5679Ext20, IERC_ACL_CORE {}
