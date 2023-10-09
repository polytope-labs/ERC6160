pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/utils/introspection/ERC165Storage.sol";

import {IERC6160Ext20, IERC5679Ext20, IERC_ACL_CORE} from "../interfaces/IERC6160Ext20.sol";

/// @notice Thrown if account is not the admin of a given role
error NotRoleAdmin();

/// @notice Thrown if account does not have required permission
error PermissionDenied();

contract MultiChainNativeERC20 is ERC165Storage, ERC20, IERC6160Ext20 {
    /// @notice InterfaceId for ERC6160Ext20
    bytes4 constant _IERC6160Ext20_ID_ = 0xbbb8b47e;

    /// @notice The Id of Role required to mint token
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");

    /// @notice The Id of Role required to burn token
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    /// @notice mapping of defined roles in the contract
    mapping(bytes32 => mapping(address => bool)) _roles;

    /// @notice mapping of admins of defined roles
    mapping(bytes32 => mapping(address => bool)) _rolesAdmin;

    constructor(address admin, string memory name, string memory symbol) ERC20(name, symbol) {
        _registerInterface(_IERC6160Ext20_ID_);
        _registerInterface(type(IERC5679Ext20).interfaceId);
        _registerInterface(type(IERC_ACL_CORE).interfaceId);

        super._mint(admin, 1_000_000 * 10e18); // 1million initial supply

        _rolesAdmin[MINTER_ROLE][admin] = true;
        _roles[MINTER_ROLE][admin] = true;

        _rolesAdmin[BURNER_ROLE][admin] = true;
        _roles[BURNER_ROLE][admin] = true;
    }

    
    /// @notice Mints token to the specified account `_to`
    function mint(address _to, uint256 _amount, bytes calldata) external {
        if(!isRoleAdmin(MINTER_ROLE) && !hasRole(MINTER_ROLE, _msgSender())) revert PermissionDenied();
        super._mint(_to, _amount);
    }

    /// @notice Burns token associated with the specified account `_from`
    function burn(address _from, uint256 _amount, bytes calldata) external {
        if(!isRoleAdmin(BURNER_ROLE) && !hasRole(BURNER_ROLE, _msgSender())) revert PermissionDenied();
        super._burn(_from, _amount);
    }

    /// @notice Checks that an account has a specified role
    /// @param _role The role to query
    /// @param _account The account to query for the given role
    function hasRole(bytes32 _role, address _account) public view returns (bool) {
        return _roles[_role][_account];
    }

    /// @notice Grants a given role to the specified account
    /// @dev This method can only be called from an admin of the given role
    /// @param _role The role to set for the account
    /// @param _account The account to be granted the specified role
    function grantRole(bytes32 _role, address _account) external {
        if(!isRoleAdmin(_role)) revert NotRoleAdmin();
        _roles[_role][_account] = true;
    }

    /// @notice Revokes a given role to the specified account
    /// @dev This method can only be called from an admin of the given role
    /// @param _role The role to revoke for the account
    /// @param _account The account whose role is to be revoked
    function revokeRole(bytes32 _role, address _account) external {
        if(!isRoleAdmin(_role)) revert NotRoleAdmin();
        _roles[_role][_account] = false;
    }

    /// @notice EIP-165 style to query for supported interfaces
    /// @param _interfaceId The interface-id to query for support
    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC165Storage) returns(bool) {
        return super.supportsInterface(_interfaceId);
    }

    /// @notice Get the Minter-Role ID
    function getMinterRole() external pure returns(bytes32) {
        return MINTER_ROLE;
    }

    /// @notice Get the Burner-Role ID
    function getBurnerRole() external pure returns(bytes32) {
        return BURNER_ROLE;
    }

    /** INTERNAL FUNCTIONS **/
    function isRoleAdmin(bytes32 role) internal view returns(bool) {
        return _rolesAdmin[role][_msgSender()];
    }
}