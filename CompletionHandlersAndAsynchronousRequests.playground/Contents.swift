//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

class ViewController : UIViewController {
    
    // Views that need to be accessible to all methods
    let jsonResult = UILabel()
    
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
                print("The Pokémon's name is", name)
                }
                if let types = (structure["types"]) as? [AnyObject]{
                    print ("This Pokémon is a", terminator: " ")
                    for type in types{
                        
                        if let typeDetails = type as? [String : AnyObject]{
//                            print("the slot number is: \(type["slot"])")
                            if let typeName = (typeDetails["type"]) as? [String : AnyObject]{
                                
                                if let typename = (typeName["name"]){
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
                        
                        if let abilityDetail = ability as? AnyObject{
                            if let abilityName = abilityDetail["ability"] as? [String : AnyObject]{
                                if let abilityname = (abilityName["name"]){
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
            
//            if let sprites = json as? [String : AnyObject] {
//                
////                print("Game index :")
////                print(sprites["sprites"])
//                if let front = sprites["sprites"] as? [String : AnyObject] {
//                    print("default sprite")
//                    print(front["front_default"])
//                    print(front["back_default"])
//                }
//                
//                
//                
//            }
            
            

            // Now we can update the UI
            // (must be done asynchronously)
            dispatch_async(dispatch_get_main_queue()) {
                self.jsonResult.text = "parsed JSON should go here"
            
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
                    
//                    // Show debug information (if a request was completed successfully)
//                    print("")
//                    print("====== data from the request follows ======")
//                    print(data)
//                    print("")
//                    print("====== response codes from the request follows ======")
//                    print(response)
//                    print("")
//                    print("====== errors from the request follows ======")
//                    print(error)
                    
                    if let d = data {
                        
                        // Parse the retrieved data
                        self.parseMyJSON(d)
                        
                    }
                    
                }
                
            }
            
        }
        
        // Define a URL to retrieve a JSON file from
        let address : String = "http://pokeapi.co/api/v2/pokemon/7/"
        
        // Try to make a URL request object
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
            
        } else {
            
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
        jsonResult.text = "..."
        jsonResult.font = UIFont.systemFontOfSize(12)
        jsonResult.numberOfLines = 0   // makes number of lines dynamic
        // e.g.: multiple lines will show up
        jsonResult.textAlignment = NSTextAlignment.Center
        
        // Required to autolayout this label
        jsonResult.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the label to the superview
        view.addSubview(jsonResult)
        
        /*
         * Add a button
         */
        let getData = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        // Make the button, when touched, run the calculate method
        getData.addTarget(self, action: #selector(ViewController.getMyJSON), forControlEvents: UIControlEvents.TouchUpInside)
        
        // Set the button's title
        getData.setTitle("Get my JSON!", forState: UIControlState.Normal)
        
        // Required to auto layout this button
        getData.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the button into the super view
        view.addSubview(getData)
        
        /*
         * Layout all the interface elements
         */
        
        // This is required to lay out the interface elements
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create an empty list of constraints
        var allConstraints = [NSLayoutConstraint]()
        
        // Create a dictionary of views that will be used in the layout constraints defined below
        let viewsDictionary : [String : AnyObject] = [
            "title": jsonResult,
            "getData": getData]
        
        // Define the vertical constraints
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-50-[getData]-[title]",
            options: [],
            metrics: nil,
            views: viewsDictionary)
        
        // Add the vertical constraints to the list of constraints
        allConstraints += verticalConstraints
        
        // Activate all defined constraints
        NSLayoutConstraint.activateConstraints(allConstraints)
        
    }
    
}

// Embed the view controller in the live view for the current playground page
XCPlaygroundPage.currentPage.liveView = ViewController()
// This playground page needs to continue executing until stopped, since network reqeusts are asynchronous
XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
