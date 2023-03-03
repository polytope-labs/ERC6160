pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol";
import {ERC165} from "openzeppelin-contracts/contracts/utils/introspection/ERC165.sol";

import {IERC6160Ext1155} from "../interfaces/IERC6160Ext1155.sol";

// errors
    error NotRoleAdmin();
    error PermissionDenied();

contract MultiChainNativeERC1155 is ERC165, ERC1155, IERC6160Ext1155 {

    // roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    mapping(bytes32 => mapping(address => bool)) _roles;
    mapping(bytes32 => mapping(address => bool)) _rolesAdmin;

    constructor() ERC1155("") {

        _rolesAdmin[MINTER_ROLE][msg.sender] = true;
        _roles[MINTER_ROLE][msg.sender] = true;

        _rolesAdmin[BURNER_ROLE][msg.sender] = true;
        _roles[BURNER_ROLE][msg.sender] = true;
    }

    // mint & burn functions
    function safeMint(address _to, uint256 _id, uint256 _amount, bytes calldata _data) external {
        if(!isRoleAdmin(MINTER_ROLE) && !hasRole(MINTER_ROLE, _msgSender())) revert PermissionDenied();
        super._mint(_to, _id, _amount, _data);
    }
    
   function safeMintBatch(address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external {
        if(!isRoleAdmin(MINTER_ROLE) && !hasRole(MINTER_ROLE, _msgSender())) revert PermissionDenied();
        super._mintBatch(to, ids, amounts, data);
   }

   function burn(address _from, uint256 _id, uint256 _amount, bytes[] calldata) external {
        bool isApproved = isApprovedForAll(_msgSender(), _from);
        bool hasBurnRole = isRoleAdmin(BURNER_ROLE) || hasRole(BURNER_ROLE, _msgSender());
        if(!isApproved && !hasBurnRole) revert PermissionDenied();
        super._burn(_from, _id, _amount);

   }

   function burnBatch(address _from, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata) external {
        bool isApproved = isApprovedForAll(_msgSender(), _from);
        bool hasBurnRole = isRoleAdmin(BURNER_ROLE) || hasRole(BURNER_ROLE, _msgSender());
        if(!isApproved && !hasBurnRole) revert PermissionDenied();
        super._burnBatch(_from, ids, amounts);
   }

   // role permissions
    function hasRole(bytes32 role, address account) public view returns (bool) {
        return _roles[role][account];
    }

    function grantRole(bytes32 role, address account) external {
        if(!isRoleAdmin(role)) revert NotRoleAdmin();
        _roles[role][account] = true;
    }

    function revokeRole(bytes32 role, address account) external {
        if(!isRoleAdmin(role)) revert NotRoleAdmin();
        _roles[role][account] = false;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC165)returns (bool) {
        return 
            interfaceId == type(IERC6160Ext1155).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    // Internal functions
    function isRoleAdmin(bytes32 role) internal view returns(bool) {
        return _rolesAdmin[role][_msgSender()];
    }
}