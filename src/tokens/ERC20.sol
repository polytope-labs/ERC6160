pragma solidity ^0.8.17;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

import "../interfaces/IERC6160Ext20.sol";

// errors
    error NotRoleAdmin();
    error NotMinter();
    error NotBurner();

contract MultiChainNativeERC20 is ERC20, IERC6160Ext20 {
    uint256 internal _totalSupply;

    // roles
    bytes32 constant MINTER_ROLE = keccak256("MINTER ROLE");
    bytes32 constant BURNER_ROLE = keccak256("BURNER ROLE");

    mapping(bytes32 => mapping(address => bool)) _roles;
    mapping(bytes32 => mapping(address => bool)) _rolesAdmin;

    constructor() ERC20("Multi Chain Native ERC20 TOken", "MCNT") {
        _totalSupply = 1_000_000 * 10e18;     // 1million total supply

        _rolesAdmin[MINTER_ROLE][msg.sender] = true;
        _roles[MINTER_ROLE][msg.sender] = true;

        _rolesAdmin[BURNER_ROLE][msg.sender] = true;
        _roles[BURNER_ROLE][msg.sender] = true;
    }

    function totalSupply() public view override returns(uint256) {
        return _totalSupply;
    }
    
    // mint & burn functions
    function mint(address _to, uint256 _amount, bytes calldata) external {
        if(!isRoleAdmin(MINTER_ROLE) && !hasRole(MINTER_ROLE, _msgSender())) revert NotMinter();
        super._mint(_to, _amount);
    }

    function burn(address _from, uint256 _amount, bytes calldata) external {
        if(!isRoleAdmin(BURNER_ROLE) && !hasRole(BURNER_ROLE, _msgSender())) revert NotBurner();
        super._burn(_from, _amount);
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

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return 
            interfaceId == type(IERC165).interfaceId || 
            interfaceId == 0x01cbdea7;
    }

    // Internal functions
    function isRoleAdmin(bytes32 role) internal view returns(bool) {
        return _rolesAdmin[role][_msgSender()];
    }
}