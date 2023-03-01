pragma solidity ^0.8.17;

// Interface for role-based access control for smart contracts
interface IERC_ACL_CORE {
    function hasRole(bytes32 role, address account) external view returns (bool);
    function grantRole(bytes32 role, address account) external;
    function revokeRole(bytes32 role, address account) external;
}
