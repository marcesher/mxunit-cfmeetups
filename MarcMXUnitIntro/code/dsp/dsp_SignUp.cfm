
<html>
	<head>
		<title>Sign up!</title>
		<style>
		*{
			font-family: Verdana;
		}
		.registration{
			background-color:blue;
		}
		th{
			text-align:left;
			font-weight:bold;
			color: white;
		}
		.message{
			color:red;
		}
		</style>
	</head>


	<body>
	
	
	<p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p><p>&nbsp;</p>
	
	
	<div align="center">
	
	<form action="../act/act_signup.cfm" method="post">
		
	<cfif len(client.message)>
		<p class="message">	<cfoutput>#client.message#</cfoutput></p>
		<cfset client.message = "">
	</cfif>
	
	<table class="registration">
		<tr>
			<th>Full Name:</th>
			<td><input type="text" name="fullname" value=""></td>
		</tr>
		
		<tr>
			<th>Email: </th>
			<td><input type="text" name="email" value=""></td>
		</tr>
		
		<tr>
			<th>Username: </th>
			<td><input type="text" name="username" value=""></td>
		</tr>
		
		<tr>
			<th>Password: </th>
			<td> <input type="text" name="password" value=""></td>
		</tr>
		
		
	</table>
	
		<p>&nbsp;</p>
		<input type="submit" value="submit">
	</form>
	
	</div>
	
	
	</body>
</html>


