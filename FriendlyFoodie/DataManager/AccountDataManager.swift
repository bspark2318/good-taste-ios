//
//  LocationDataManager.swift
//  FriendlyFoodie
//
//  Created by BumSu Park on 2022/03/11.
//

import Foundation

public class AccountDataManager {
    public static let sharedInstance = AccountDataManager();
    
    // Information Storage
    var accountArray : [AccountData] = []
    
    // Making the class a singleton
    fileprivate  init() {
    }
    
    // MARK: AccountDataManager Class Methods
    
    // Load account data
    func loadAccountDataFromPlist() {
        let dataPath = Bundle.main.path(forResource: "Accounts", ofType: "plist")
        let plist = NSDictionary(contentsOfFile: dataPath ?? "") ?? NSDictionary()
        guard let accounts = plist["accounts"] as? [NSDictionary] else {
            print("No Accounts provided")
            return
        }
    
        // Convert into proper data structures
        for account in accounts {
            if let id = account["id"] as? String,
               let first_name = account["first_name"] as? String,
               let last_name = account["last_name"] as? String,
               let profile_pic = account["profile_pic"] as? String,
               let description = account["description"] as? String,
               let year_joined = account["year_joined"] as? Int,
               let endorsed_places = account["endorsed_places"] as? [Int] {
                
                let newAccount = AccountData(
                    id: id,
                    first_name: first_name,
                    last_name: last_name,
                    profile_pic: profile_pic,
                    description: description,
                    year_joined: year_joined,
                    endorsed_places: endorsed_places)
                accountArray.append(newAccount)
            }
        }
        print("Accounts Successfully loaded");
        print(accountArray)
        return ;
    }
    
    // Retrieve an account with the given account_id
    func findAccount(account_id: String) -> AccountData {
        for account in accountArray {
            if account.id == account_id {
                return account;
            }
        }
        return AccountData(id: "N/A", first_name: "Not", last_name: "available",
                           profile_pic: "profile_pic_placeholder",
                           description: "Not available", year_joined: -1, endorsed_places: []);
    }
    
    // Edit information for the user's account
    func editMyAccount(account_id: String, first_name: String, last_name: String, description: String) -> AccountData? {
        for (index, account) in accountArray.enumerated() {
            if account.id == account_id {
                accountArray[index].first_name = first_name
                accountArray[index].last_name = last_name
                accountArray[index].description = description
                
                return accountArray[index]
            }
        }
        return nil
    }
    
    
    // Returns whether the place is endorsed (true if newly endorsed)
    // Edits the endorsement list of the place
    func editPlaceEndorsement(accountId: String, placeId: Int) -> Bool {
        
        for (i, account) in accountArray.enumerated() {
            if account.id == accountId {
                
                for (j, endorsedId) in account.endorsed_places.enumerated() {
                    if endorsedId == placeId {
                        accountArray[i].endorsed_places.remove(at: j)
                        print("Removed place")
                        print(accountArray[i])
                        return false
                    }
                }
                
                print("Adding place")
                accountArray[i].endorsed_places.append(placeId)
                print(accountArray[i])
                return true
            }
        }
        print("Nothing happened")
        return false
    }
    
    // Fetch the data of people who endorsed the place
    func fetchFriendsEndorsement(memberId: String, endorsedList: [String]) -> [AccountData] {
        var returnList: [AccountData] = []
        for endorsedId in endorsedList {
            for item in accountArray {
                if (item.id == endorsedId && item.id != memberId) {
                    returnList.append(item)
                }
            }
        }
        
        return returnList
    }
    
    // Fetch the number of people who endorsed the place
    func fetchFriendsEndorsementCount(memberId: String, endorsedList: [String]) -> Int {
        var count = 0
        for endorsedId in endorsedList {
            for item in accountArray {
                if (item.id == endorsedId && item.id != memberId) {
                    count += 1
                }
            }
        }
        
        return count
    }
}
