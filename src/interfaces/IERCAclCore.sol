pragma solidity ^0.8.17;

/**
 * @dev Interface of the EIP5982 standard, as defined in
 * https://github.com/polytope-labs/EIPs/blob/master/EIPS/eip-5982.md
 *
 * The EIP-165 identifier of this interface is 0x6bb9cd16
 */
interface IERC_ACL_CORE {
    function hasRole(bytes32 role, address account) external view returns (bool);
    function grantRole(bytes32 role, address account) external;
    function revokeRole(bytes32 role, address account) external;
}
