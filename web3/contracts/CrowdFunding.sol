// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Project{
        address owner;
        string tittle;
        string description;
        uint256 deadline;
        uint256 target;
        uint256 amountCollected;
        string image;
        uint256[] donations;
        address[] donators;
    }

    mapping(uint256 => Project) public Projects;
    uint256 public projectCount;

    function createProject (address _owner, string memory _tittle, string memory _description, uint256 _deadline, uint256 _target, uint256 _amountCollected, string memory _imageURL)public returns(uint256) {
        projectCount++;
        Project storage project = Projects[projectCount];
        require(project.deadline < block.timestamp , "The deadline should be a date in the future");
        project.owner = _owner;
        project.tittle = _tittle;
        project.description = _description;
        project.deadline = _deadline;
        project.target = _target;
        project.amountCollected = _amountCollected;
        project.image = _imageURL;

        return projectCount;
    }

    function donateOnProjects(uint256 _id)payable public {
        Project storage project = Projects[_id];
        project.donations.push(msg.value);
        project.donators.push(msg.sender);
        (bool sent, ) = payable(project.owner).call{value : msg.value}("");
        if(sent){
            project.amountCollected = project.amountCollected + msg.value;
        }
    }

    function getDonators(uint256 _id) view public returns(uint256[] memory, address[] memory ){
        return(Projects[_id].donations, Projects[_id].donators);    
    }
    function getAllProjects() view public returns(Project[] memory) {  
        Project[] memory allProjects = new Project[](projectCount); 
        for (uint i = 0; i< projectCount; i++){
            Project storage project = Projects[i];
            allProjects[i] = project;
        }
        return allProjects;
    }
}