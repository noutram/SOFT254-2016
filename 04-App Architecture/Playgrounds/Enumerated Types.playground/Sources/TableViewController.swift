import UIKit


//Bare bones table view for displaying a list of strings
public class TableViewController: UITableViewController {

   //This needs to be populated
   public var data : [String]?
   
   //Delegate methods
   public override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if let array = data {
         return array.count
      } else {
         return 0
      }
   }
   
   // Data Source Methods
   //Return a UITableViewCell on demand
   public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell : UITableViewCell
      if let c = self.tableView.dequeueReusableCell(withIdentifier: "cell") {
         cell = c
      } else {
         cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
      }
      
      if let str = data?[indexPath.row] {
         cell.textLabel?.text = str
      }
      
      return cell
   }
   
}
