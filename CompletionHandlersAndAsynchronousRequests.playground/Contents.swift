//: Playground - noun: a place where people can play

import UIKit
import XCPlayground
var URL: String = "http://pokeapi.co/api/v2/pokemon/"
var URLend: String = "/"

extension UIView
{
    func centerHorizontallyInSuperview()
    {
        let c: NSLayoutConstraint = NSLayoutConstraint(item: self,
                                                       attribute: NSLayoutAttribute.CenterX,
                                                       relatedBy: NSLayoutRelation.Equal,
                                                       toItem: self.superview,
                                                       attribute: NSLayoutAttribute.CenterX,
                                                       multiplier:1,
                                                       constant: 0)
        
        // Add this constraint to the superview
        self.superview?.addConstraint(c)
    }
}
class ViewController : UIViewController {
    
    let inputGiven = UITextField(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
    var JSONname = ""
    var jsonTypeArray: [String] = []
    //    var JSONability: [String] = []
    var JSONsprite = ""
    var JsonTypeString = "Pokémon type "
    
    
    // Views that need to be accessible to all methods
    let jsonName = UILabel()
    let jsonType = UILabel()
    
    // If data is successfully retrieved from the server, we can parse it here
    func parseMyJSON(theData : NSData) {
        
        // Print the provided data
        print("")
        print("====== the data provided to parseMyJSON is as follows ======")
        //print(theData)
        
        // De-serializing JSON can throw errors, so should be inside a do-catch structure
        do {
            
            // Do the initial de-serialization
            // Source JSON is here:
            // http://pokeapi.co/
            //
            let json = try NSJSONSerialization.JSONObjectWithData(theData, options: NSJSONReadingOptions.AllowFragments) as! AnyObject
            
            // Now we can parse this...
            
            if let structure = json as? [String : AnyObject] {
                
                if let name = (structure["name"]){
                    JSONname = name as! String
                    print("The Pokémon's name is", name)
                }
                
                if let types = (structure["types"]) as? [AnyObject]{
                    print ("This Pokémon is a", terminator: " ")
                    for type in types{
                        
                        if let typeDetails = type as? [String : AnyObject]{
                            if let typeName = (typeDetails["type"]) as? [String : AnyObject]{
                                
                                if let typename = (typeName["name"]){
                                    jsonTypeArray += [typename as! String]
                                    
                                    print (typename, terminator:"")
                                    
                                }
                                
                            }
                        }
                        
                    }
                    print (" type")
                    
                    
                }
                
                
                
                
                if let abilities = structure["abilities"] as? [AnyObject]{
                    print("This Pokémon's abilities are", terminator: " ")
                    // iterate over all the ability
                    for ability in abilities {
                        var i = 0
                        if let abilityDetail = ability as? AnyObject{
                            if let abilityName = abilityDetail["ability"] as? [String : AnyObject]{
                                if let abilityname = (abilityName["name"]){
                                    //                                    JSONability[i] = abilityname as! String
                                    i += 1
                                    print(abilityname, terminator:" ")
                                    
                                }
                                
                            }
                            
                        }
                    }
                    print(terminator:"\n")
                    
                    
                    
                }
                if let sprites = structure as? [String : AnyObject] {
                    
                    if let sprite = sprites["sprites"] as? [String : AnyObject] {
                        
                        if let front = sprite["front_default"]{
                            print("Default sprite front")
                            print(front)
                        }
                        print("Default sprite back")
                        if let back = sprite["back_default"]{
                            print(back)
                        }
                        if let frontShiny = sprite["front_shiny"]{
                            print("Shiny sprite front")
                            print(frontShiny)
                        }
                        if let backShiny = sprite["back_shiny"]{
                            print("Shiny sprite back")
                            print(backShiny)
                        }
                    }
                    
                }
                
            }
            
            
            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                
                self.jsonName.text = self.JSONname
//                var JsonTypeString = "Pokémon type "
                
//                self.JsonTypeString += self.jsonTypeArray[0]
//                if (self.jsonTypeArray.count > 1){
//                    self.JsonTypeString += self.jsonTypeArray[1]
//                }
//                self.jsonType.text = self.JsonTypeString
                
            }
        } catch let error as NSError {
            print ("Failed to load: \(error.localizedDescription)")
        }
        
        
    }
    
    // Set up and begin an asynchronous request for JSON data
    func getMyJSON() {
        
        // Define a completion handler
        // The completion handler is what gets called when this **asynchronous** network request is completed.
        // This is where we'd process the JSON retrieved
        let myCompletionHandler : (NSData?, NSURLResponse?, NSError?) -> Void = {
            
            (data, response, error) in
            
            // This is the code run when the network request completes
            // When the request completes:
            //
            // data - contains the data from the request
            // response - contains the HTTP response code(s)
            // error - contains any error messages, if applicable
            
            // Cast the NSURLResponse object into an NSHTTPURLResponse objecct
            if let r = response as? NSHTTPURLResponse {
                
                // If the request was successful, parse the given data
                if r.statusCode == 200 {
                    
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        func createURL() -> (String?){
            
            //            if let userInput = inputGiven.text{
            let addr = URL + inputGiven.text! + URLend
            print(addr)
            return(addr)
            
        }
        
        // Define a UR to retrieve a JSON file from
        if let address = createURL(){
            if let url = NSURL(string: address) {
                
                // We have an valid URL to work with
                print(url)
                
                // Now we create a URL request object
                let urlRequest = NSURLRequest(URL: url)
                
                // Now we need to create an NSURLSession object to send the request to the server
                let config = NSURLSessionConfiguration.defaultSessionConfiguration()
                let session = NSURLSession(configuration: config)
                
                // Now we create the data task and specify the completion handler
                let task = session.dataTaskWithRequest(urlRequest, completionHandler: myCompletionHandler)
                
                // Finally, we tell the task to start (despite the fact that the method is named "resume")
                task.resume()
                
            }
        }
            
            // Try to make a URL request object
        else {
            
            // The NSURL object could not be created
            print("Error: Cannot create the NSURL object.")
            
        }
        
    }
    
    // This is the method that will run as soon as the view controller is created
    override func viewDidLoad() {
        
        // Sub-classes of UIViewController must invoke the superclass method viewDidLoad in their
        // own version of viewDidLoad()
        super.viewDidLoad()
        
        // Make the view's background be gray
        view.backgroundColor = UIColor.lightGrayColor()
        
        /*
         * Further define label that will show JSON data
         */
        
        // Set the label text and appearance
        jsonName.text = "..."
        jsonName.font = UIFont.systemFontOfSize(12)
        jsonName.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonName.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonName.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonName)
        
        jsonType.font = UIFont.systemFontOfSize(12)
        jsonType.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonType.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonType.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonType)
        
        
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Submit", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)
        
        // add text box
        let UserInput = UILabel()
        
        
        
        // Set the label text and appearance
        UserInput.text = "Pokédex#"
        UserInput.font = UIFont.systemFontOfSize(24)
        
        // Required to autolayout this label.
        UserInput.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the amount label into the superview
        view.addSubview(UserInput)
        
        /*
         * Set up text field for the amount
         */
        // Set the label text and appearance
        inputGiven.borderStyle = UITextBorderStyle.RoundedRect
        inputGiven.font = UIFont.systemFontOfSize(15)
        inputGiven.placeholder = "1-811"
        inputGiven.backgroundColor = UIColor.whiteColor()
        inputGiven.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        inputGiven.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this field
        inputGiven.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the amount text field into the superview
        view.addSubview(inputGiven)
        
        
        
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonName,
            "getData": getData,
            "UserInput": UserInput,
            "inputField": inputGiven,
//            "type": jsonType,
            //            "ability": JSONability
        ]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[UserInput]-[inputField]-[getData]-[title]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        jsonName.centerHorizontallyInSuperview()
        getData.centerHorizontallyInSuperview()
        UserInput.centerHorizontallyInSuperview()
        inputGiven.centerHorizontallyInSuperview()


        NSLayoutConstraint.activateConstraints(allConstraints)
        
        
        
    }
    
}




// Embed the view controller in the live view for the current playground page
XCPlaygroundPage.currentPage.liveView = ViewController()
// This playground page needs to continue executing until stopped, since network reqeusts are asynchronous
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
