// Javascript for create_form and update_form HTML pages

// get the input and validation elements
const titleInput = document.getElementById("title"); // Todo title input
const titleValidation = document.getElementById("titleValidation"); // Title validation message
const dueTimeInput = document.getElementById("dueTime"); // Due time input
const dueTimeValidation = document.getElementById("dueTimeValidation"); // Due time validation message
const submitButton = document.getElementById("submit"); // Submit button
const createdTimeInput=(document.getElementById('createdTime'))
if (createdTimeInput!==  null){
    console.log(createdTimeInput)
    createdTime=new Date(createdTimeInput.value)
}
else{
    createdTime=null
}

let titleFlag = 0; // Flag for title validity
let dueTimeFlag = 0; // Flag for due time validity



if (createdTime !== null){ //created time is null for created form
    console.log("created time not null"+createdTime)
    titleFlag=1 //flags should be initialized as 1 in update form because the default values are valid 
    dueTimeFlag=1
}


//make a function to validate due time for reusability in the code
const validateDueTime = function(){
    submitButton.setAttribute("disabled",true)
    submitButton.classList.add("disabled-btn")

    const dueTime = new Date(dueTimeInput.value);
    dueTimeValidation.classList.add("d-none");
    dueTimeValidation.classList.remove("text-danger");

    if (createdTime !== null){ //createdTime is defined only in updated_form and not in created_form
        if (dueTime < createdTime || isNaN(dueTime)) {
            dueTimeValidation.classList.remove("d-none");
            dueTimeValidation.classList.add("text-danger");
            dueTimeValidation.innerText ="*Due time must be greater than the created time of the todo";
            dueTimeInput.classList.add('is-invalid')
            dueTimeFlag = 0;
        }
        else{
            // valid condition for update form
            dueTimeFlag=1
            dueTimeInput.classList.remove('is-invalid')

        }

    }

    //executed if create form is invalid
    else if(dueTime.getTime()+60000 < new Date() || isNaN(dueTime)){ //added one minute
        
        dueTimeValidation.classList.remove("d-none");
        dueTimeValidation.classList.add("text-danger");
        dueTimeValidation.innerText = "*Due time must be greater than current time";
        dueTimeInput.classList.add('is-invalid')

        dueTimeFlag = 0;
    } 
    
    //executed if create form is valid
    else {
        dueTimeFlag = 1;
        dueTimeInput.classList.remove('is-invalid')

    }

    //call the function to enable/disable the submit button
    validateForm();
}



// Todo Title validation
events=["blur","input"] 
events.forEach(event=>{
    titleInput.addEventListener(event, function () {

        //Initialize the attributes
        submitButton.setAttribute("disabled",true)
        submitButton.classList.add("disabled-btn")
        const title = titleInput.value;
        const length = title.length; // length of the todo title
        titleValidation.classList.add("d-none");
        titleValidation.classList.add("text-dark");
        titleValidation.classList.remove("text-danger");
        
    
        if (length > 0) { // Non empty title , mark valid
            titleValidation.classList.remove("d-none");
            titleValidation.classList.remove("text-danger");
            titleValidation.classList.remove("text-dark");
            titleInput.classList.remove('is-invalid')
            titleValidation.innerText = length + "/100";
            titleFlag=1
        }
    
        if (length === 0) { // Empty title , mark invalid
            titleFlag=0
            titleValidation.classList.add("text-danger");
            titleValidation.classList.remove("d-none");
            titleValidation.classList.remove("text-dark");
            titleInput.classList.add('is-invalid')

            titleValidation.innerText = "*required";
        }

        validateForm();
    });



    // Due time validation
    dueTimeInput.addEventListener(event, function () {
        validateDueTime();
    });
})

// Function to enable/disable submit button based on validation
function validateForm() {
    console.log("titleFlag"+titleFlag)
    console.log("dueTimeFlag"+dueTimeFlag)

    if (titleFlag && dueTimeFlag){
        submitButton.removeAttribute("disabled")
        submitButton.classList.remove("disabled-btn")
    }
}

function validateDueTimeEveryMinute(callback) {
    let lastMinute = new Date().getMinutes(); // Get the current minute

    setInterval(() => {
        let currentMinute = new Date().getMinutes();
        if (currentMinute !== lastMinute) { // Check if the minute has changed
            lastMinute=currentMinute
            callback();
        }
    }, 1000); // Check every second
}

if (createdTime == null){
        
    validateDueTimeEveryMinute(() => {
        validateDueTime()
    });
}

