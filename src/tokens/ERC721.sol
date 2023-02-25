pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";

import "../interfaces/IERC6160Ext721.sol";

error PermissionDenied();
error NotMinter();
error NotRoleAdmin();

contract MultiChainNativeERC721 is ERC721, IERC6160Ext721 {

    // roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    mapping(bytes32 => mapping(address => bool)) _roles;
    mapping(bytes32 => mapping(address => bool)) _rolesAdmin;

    constructor() ERC721("Multi Chain Native ERC721", "MCNT") {

        _rolesAdmin[MINTER_ROLE][msg.sender] = true;
        _roles[MINTER_ROLE][msg.sender] = true;

        _rolesAdmin[BURNER_ROLE][msg.sender] = true;
        _roles[BURNER_ROLE][msg.sender] = true;
    }

    // mint & burn functions
    function safeMint(address _to, uint256 _tokenId, bytes calldata _data) external {
        if(!isRoleAdmin(MINTER_ROLE) && !hasRole(MINTER_ROLE, _msgSender())) revert NotMinter();
        super._safeMint(_to, _tokenId, _data);
    }

    function burn(address, uint256 _tokenId, bytes calldata) external {
        bool isApproved = _isApprovedOrOwner(_msgSender(), _tokenId);
        bool canBurn = isRoleAdmin(BURNER_ROLE) || hasRole(BURNER_ROLE, _msgSender());
        if(!isApproved && !canBurn) revert PermissionDenied();
        super._burn(_tokenId);
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

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165)returns (bool) {
        return 
            interfaceId == 0x01cbdea7 ||
            super.supportsInterface(interfaceId);
    }

    // Internal functions
    function isRoleAdmin(bytes32 role) internal view returns(bool) {
        return _rolesAdmin[role][_msgSender()];
    }

}