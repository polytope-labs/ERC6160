// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "openzeppelin/token/ERC20/ERC20.sol";
import "openzeppelin/utils/introspection/ERC165Storage.sol";

import {IERC6160Ext20, IERC5679Ext20, IERC_ACL_CORE} from "../interfaces/IERC6160Ext20.sol";

/// @notice Thrown if account is not the admin of a given role
error NotRoleAdmin();

/// @notice Thrown if account does not have required permission
error PermissionDenied();

contract ERC6160Ext20 is ERC165Storage, ERC20, IERC6160Ext20 {
	/// @notice InterfaceId for ERC6160Ext20
	bytes4 private constant IERC6160Ext20_ID = 0xb6ba5da3;

	/// @notice The Id of Role required to mint token
	bytes32 public constant MINTER_ROLE = keccak256("MINTER ROLE");

	/// @notice The Id of Role required to burn token
	bytes32 public constant BURNER_ROLE = keccak256("BURNER ROLE");

	/// @notice mapping of defined roles in the contract
	mapping(bytes32 => mapping(address => bool)) internal _roles;

	/// @notice mapping of admins of defined roles
	mapping(bytes32 => mapping(address => bool)) internal _rolesAdmin;

	constructor(address admin, string memory name, string memory symbol) ERC20(name, symbol) {
		_registerInterface(IERC6160Ext20_ID);
		_registerInterface(type(IERC5679Ext20).interfaceId);
		_registerInterface(type(IERC_ACL_CORE).interfaceId);

		_rolesAdmin[MINTER_ROLE][admin] = true;
		_rolesAdmin[BURNER_ROLE][admin] = true;

		_roles[MINTER_ROLE][admin] = true;
		_roles[BURNER_ROLE][admin] = true;
	}

	/// @notice Mints token to the specified account `_to`
	function mint(address _to, uint256 _amount) public {
		if (!_isRoleAdmin(MINTER_ROLE) && !hasRole(MINTER_ROLE, _msgSender())) revert PermissionDenied();
		super._mint(_to, _amount);
	}

	/// @notice Burns token associated with the specified account `_from`
	function burn(address _from, uint256 _amount) public {
		if (!_isRoleAdmin(BURNER_ROLE) && !hasRole(BURNER_ROLE, _msgSender())) revert PermissionDenied();
		super._burn(_from, _amount);
	}

	/// @notice Grants a given role to the specified account
	/// @dev This method can only be called from an admin of the given role
	/// @param _role The role to set for the account
	/// @param _account The account to be granted the specified role
	function grantRole(bytes32 _role, address _account) public {
		if (!_isRoleAdmin(_role)) revert NotRoleAdmin();
		_roles[_role][_account] = true;
	}

	/// @notice Revokes a given role to the specified account
	/// @dev This method can only be called from an admin of the given role
	/// @param _role The role to revoke for the account
	/// @param _account The account whose role is to be revoked
	function revokeRole(bytes32 _role, address _account) public {
		if (!_isRoleAdmin(_role)) revert NotRoleAdmin();
		_roles[_role][_account] = false;
	}

	/// @notice Changes the admin account to the provided address
	/// @dev This method can only be called from an admin of the given role
	/// @param newAdmin Address of the new admin
	function changeAdmin(address newAdmin) public {
		if (!_isRoleAdmin(MINTER_ROLE) || !_isRoleAdmin(BURNER_ROLE)) revert NotRoleAdmin();

		delete _rolesAdmin[MINTER_ROLE][_msgSender()];
		delete _rolesAdmin[BURNER_ROLE][_msgSender()];

		if (newAdmin == address(0)) {
			return;
		}

		_rolesAdmin[MINTER_ROLE][newAdmin] = true;
		_rolesAdmin[BURNER_ROLE][newAdmin] = true;
	}

	/// @notice EIP-165 style to query for supported interfaces
	/// @param _interfaceId The interface-id to query for support
	function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC165Storage) returns (bool) {
		return super.supportsInterface(_interfaceId);
	}

	/// @notice Checks that an account has a specified role
	/// @param _role The role to query
	/// @param _account The account to query for the given role
	function hasRole(bytes32 _role, address _account) public view returns (bool) {
		return _roles[_role][_account];
	}

	/// @notice Get the Minter-Role ID
	function getMinterRole() public pure returns (bytes32) {
		return MINTER_ROLE;
	}

	/// @notice Get the Burner-Role ID
	function getBurnerRole() public pure returns (bytes32) {
		return BURNER_ROLE;
	}

	/**
	 * INTERNAL FUNCTIONS *
	 */
	function _isRoleAdmin(bytes32 role) internal view returns (bool) {
		return _rolesAdmin[role][_msgSender()];
	}
}
