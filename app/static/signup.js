// JAvascript for signup.html , mainly for form validation

// define flags for all types of inputs, flag=1 when the input is validated
let nameFlag=0
let userNameFlag=0
let passwordFlag=0
let passwordLengthFlag=0 //flag for passwrd length
let passwordRegexFlag=0 //flag for regex
let confirmPasswordFlag=0

// get the input and validation elements for password and confirm passwords
const password = document.getElementById('password');
const confirmPassword = document.getElementById('confirmPassword');
const passwordValidationLength = document.getElementById('passwordValidationLength');
const passwordValidationRegex = document.getElementById('passwordValidationRegex');
const confirmPasswordValidation = document.getElementById('confirmPasswordValidation');

// trigger on the basis of following events
const events = ['blur', 'input'];

// regex for password
//must contain at least 1 lowercase,uppercase and special characters each with minimum length 8
const regexPassword = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;

// submit button
submit=document.getElementById("submit")

// check whether password === confirm password
const comparePasswords = function(){
    confirmPasswordValidation.classList.add("d-none");
    confirmPasswordValidation.classList.remove("text-danger")
    confirmPasswordValidation.classList.remove("text-success")
    confirmPasswordFlag=0

    // check only if password is valid and confirm password is not valid
    if (passwordFlag && confirmPassword.value!==""){
        confirmPasswordValidation.classList.remove("d-none")

        // password and confirm password doesn't match
        if(password.value!==confirmPassword.value){
            confirmPasswordValidation.classList.add("text-danger")
            confirmPasswordValidation.innerText="❌ password and confirm password must match"
            confirmPasswordFlag=0
        }

        // password and confirm password match
        else{
            confirmPasswordValidation.classList.add("text-success")
            confirmPasswordValidation.innerText="✅ password and confirm password must match"
            confirmPasswordFlag=1
        }
    }
}

// add event listeners for each defined event in the array events
events.forEach(event => {
    password.addEventListener(event, function () {
        //Initialize the input attributes to mimic invalid scenario by default
        submit.classList.add("disabled-btn")
        submit.setAttribute("disabled", "true");
        passwordFlag=0
        passwordLengthFlag=0
        passwordRegexFlag=0
        
        // hide the validation messages before validation
        passwordValidationLength.classList.add("d-none");  
        passwordValidationRegex.classList.add("d-none");  
        passwordValidationLength.innerText = ""; // Clear previous messages
        passwordValidationRegex.innerText = ""; // Clear previous messages
        password.classList.remove("is-invalid")

        // check whether password is not empty
        if(password.value!==""){

        
            passwordValidationLength.classList.remove("d-none");
            passwordValidationRegex.classList.remove("d-none");

            // check whether length is less than 8
            if (password.value.length < 8) {
                passwordValidationLength.classList.remove("text-success");
                passwordValidationLength.classList.add("text-danger");
                passwordValidationLength.innerText+= "❌ Password must be at least 8 characters long.\n";
                passwordLengthFlag=0
                password.classList.add("is-invalid")
            }

            // executed when length is valid
            else{
                passwordValidationLength.classList.remove("text-danger");
                passwordValidationLength.classList.add("text-success");
                passwordValidationLength.innerText += "✅ Password must be at least 8 characters long.\n";
                passwordLengthFlag=1
                // password.classList.add("is-invalid")

            }

            // if regex test fails
            if (!regexPassword.test(password.value)) {
                console.log("not matching")
                passwordValidationRegex.classList.remove("text-success");
                passwordValidationRegex.classList.add("text-danger");
                passwordValidationRegex.innerText += "❌ Password must contain at least 1 lowercase letter, 1 uppercase letter, 1 special character and 1 digit.\n";
                passwordRegexFlag=0
                password.classList.add("is-invalid")

            }

            // if regex is
            else{
                console.log("matching")
                passwordValidationRegex.classList.remove("text-danger");
                passwordValidationRegex.classList.add("text-success");
                passwordValidationRegex.innerText += "✅ Password must contain at least 1 lowercase letter, 1 uppercase letter, 1 special character and 1 digit.\n";
                passwordRegexFlag=1
                // password.classList.add("is-invalid")

            }
        }

        // else block will be excuted if password is empty after the event triggers
        else{
            passwordValidationLength.classList.add('text-danger')
            passwordValidationLength.classList.remove('text-success')
            passwordValidationLength.classList.remove('d-none')
            passwordValidationLength.innerText="*required"
            password.classList.add("is-invalid")

        }

        // password flag is 1 only when both length and regex are validated
        passwordFlag=passwordLengthFlag&&passwordRegexFlag
        
        // compare the password and confirm passwords
        comparePasswords();
        
        // remove the disabled-btn attribute if every flag is valid
        if (nameFlag&&userNameFlag&&passwordFlag&&confirmPasswordFlag){
            submit.removeAttribute("disabled")
            submit.classList.remove("disabled-btn")}
    });

    // check whether confirm password === password 
    confirmPassword.addEventListener(event,function(){
        submit.setAttribute("disabled","true")
        submit.classList.add("disabled-btn")
        comparePasswords();
        if (nameFlag&&userNameFlag&&passwordFlag&&confirmPasswordFlag){
            submit.removeAttribute("disabled")
            submit.classList.remove("disabled-btn")}

    })
});

//validate the name inputs 
// nameInputs array to store the elements for firstname, middle name and lastname inputs
const nameInputs=Array.from(document.getElementsByClassName('name'))
//regex for name to allow only alphabets
const regexValidName = /^[A-Za-z]+$/;

let nameFlags={
    "firstName":0,
    "middleName":1, //middle name is 1 by default because empty middle names are allowed
    "lastName":1 //last name is 1 by default because empty last names are allowed

}
nameInputs.forEach( nameInput => {
    
    
    // get the validation ids for the corresponding name input
    let validationId=nameInput.id+"Validation"
    let nameField=nameInput.id //name input id
    const nameInputValidation=document.getElementById(validationId) //validation div

    // add event listeners for each event in events array
    events.forEach(event=> {
        nameInput.addEventListener(event,function(){
            // trim the name and make it lower cased
            nameInput.value=nameInput.value.trim().toLowerCase()

            // disable submit till validated
            submit.classList.add("disabled-btn")
            submit.setAttribute("disabled", "true");
            nameInputValidation.classList.add('d-none')
            nameInputValidation.innerText = ""
            nameInput.classList.remove('is-invalid')
            // name flag is initialized to be 1
            nameFlags[nameField]=1

            // check whether firstname is empty
            if (nameInput.id=='firstName' && nameInput.value===""){
                nameFlags[nameField]=0
                nameInputValidation.classList.remove('d-none')
                nameInputValidation.innerText="*required" //required message
                nameInput.classList.add('is-invalid')

            }
            

            //check maxlength constraint satisfaction
            const MAXNAMELENGTH=20
            if (nameInput.value.length>MAXNAMELENGTH){
                nameFlags[nameField]=0
                nameInputValidation.classList.remove('d-none')
                nameInputValidation.innerText+=nameInput.placeholder+" cannot be more than "+MAXNAMELENGTH+" characters\n"
                nameInput.classList.add('is-invalid')

            }

            // check regex test
            if ((nameInput.value!=="") && (!regexValidName.test(nameInput.value)==true)){
                nameFlags[nameField]=0
                
                nameInputValidation.classList.remove('d-none')
                nameInputValidation.innerText+=nameInput.placeholder+" should contain only alphabets\n"
                nameInput.classList.add('is-invalid')
                
            }
            
            // Enable the submit button if all flags are 1
            nameFlag=nameFlags['firstName']&&nameFlags['middleName']&&nameFlags['lastName']
            if (nameFlag&&userNameFlag&&passwordFlag&&confirmPasswordFlag){
                submit.removeAttribute("disabled")
                submit.classList.remove("disabled-btn")
            }

        })
        
    })
    
})

// validate userName
const userName=document.getElementById('userName')
const userNameValidation=document.getElementById('userNameValidation')
events.forEach(event=>{
    userName.addEventListener(event,function(){
        //initalizing the validation messages and submit buttons
        submit.classList.add("disabled-btn")
        submit.setAttribute("disabled", "true");
        userName.value=userName.value.trim()
        userNameValidation.classList.remove("d-none")
        userNameValidation.classList.add('text-danger')
        userNameValidation.innerText=""

        //initialize as valid
        userNameFlag=1
        // check if username is empty
        if (userName.value===""){
            userNameValidation.classList.remove("d-none")
            userNameValidation.innerText="*required"
            userNameFlag=0
        }
        

        else{
            //check minlength and maxlength satisfaction
            const MINLENGTH=5
            const MAXLENGTH=40
            if (userName.value.length<MINLENGTH){
                // userNameValidation.classList.remove("d-none")
                userNameFlag=0
                userNameValidation.innerText=userName.placeholder+" cannot be less than 5 characters"
            }
            if (userName.value.length>MAXLENGTH){
                userNameFlag=0
                userNameValidation.innerText=userName.placeholder+" cannot me more than 40 characters"
            }

            console.log(userNameFlag)
            if (userNameFlag==1){ //check inwhether the username already exists if it is valid
                
                // csrf token to send a post request 
                const csrfToken = document.getElementById("csrf_token").value; 

                //send the username to the flask backend to query the database to check whether 
                //the username exist in realtime
                fetch(checkUserNameURL, {
                    method: "POST",
                    headers: { "Content-Type": "application/json" ,
                        "X-CSRFToken": csrfToken
                    },
                    body: JSON.stringify({ userName : userName.value })
                })
                .then(response => response.json()) //get response
                .then(data => {
                    if (data.exists) { //check the exists attribute to find whether a user exists
                        userNameFlag=0
                        userNameValidation.classList.remove("text-success")
                        userNameValidation.classList.add("text-danger")
                        userNameValidation.innerText = "Username already taken!";
                        
                    } else { //executed if a user doesn't exist
                        userNameFlag=1
                        userNameValidation.classList.remove("text-danger")
                        userNameValidation.classList.add("text-success")
                        userNameValidation.innerText= "Username available!";
                    }
                })
                .catch(error => console.error("Error:", error));
            }
        }
        
        //enable the submit button if all fields are validated
        if (nameFlag&&userNameFlag&&passwordFlag&&confirmPasswordFlag){
            submit.removeAttribute("disabled");
            submit.classList.remove("disabled-btn")
        }
    })
})


// Submit button
// form=document.getElementById("form")
// form.addEventListener('submit',function(event){
//     submit.classList.add("disabled-btn")
//     submit.setAttribute("disabled","true")
//     console.log(userNameFlag && nameFlag && passwordFlag)
//     event.preventDefault()
//     if (userNameFlag && nameFlag && passwordFlag){
//         const csrfToken = document.getElementById("csrf_token").value; 
//         console.log("sending data to flask")
//         fetch(signupURL, {
//             method: "POST",
//             headers: { "Content-Type": "application/json" ,
//                 "X-CSRFToken": csrfToken
//             },
//             body: JSON.stringify({ firstName:nameInputs[0].value,
//                 middleName:nameInputs[1].value,
//                 lastName:nameInputs[2].value,
//                 userName : userName.value,
//                 password :password.value })
//         })
//         .then(response =>response.json())
//         .then(data => {
//             window.location.href=data.redirect
//         })
        
//     }
//     submit.removeAttribute("disabled");
//     submit.classList.remove("disabled-btn")
    
// })
