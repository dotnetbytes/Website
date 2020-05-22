---
layout: page
title: Contact Us
sitemap: true
---

<style>
    p.hidden {
        visibility:hidden;
    }

    #Name, #Email {
        width: 490px;
        height: 30px;
        padding-left:10px;
    }

    #Message {
        height: 200px;
        width: 480px;
        padding: 10px;
    }

    #Submit {
        width: 100px;
        height: 30px;
    }
</style>

<form name="contact" netlify netlify-honeypot="bot-field">
    <p class="hidden">
        <label>Don’t fill this out if you're human: <input name="bot-field" /></label>
    </p>
    <p>
        <label>
            Your Name:<br/>
            <input type="text" id="Name" name="name" required>
        </label>   
    </p>
    <p>
        <label>
            Email:<br/>
            <input type="email" id="Email" name="name" required>
        </label>
    </p>
    <p>
        <label>
            Message:<br/>
            <textarea name="message" id="Message" required></textarea>
        </label>
    </p>
    <p>
        <div netlify-recaptcha></div>
    </p>
    <p>
        <button type="submit" id="Submit">Submit</button>
    </p>
</form>