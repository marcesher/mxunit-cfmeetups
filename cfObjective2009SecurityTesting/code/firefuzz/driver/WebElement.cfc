<cfcomponent hint="Represents an element in a page" output="false">
<cfscript>
  this.webElement = "";
    
  function init(webElement){
   this.webElement = arguments.webElement;
   return this;
  }
    
  //TO DO: Accept int as 2nd param, which indicates mouse and keyboard events - KEYPRESS.KEYDOWN ...
  function sendKeys(keys){
	var localKeys = arrayNew(1);
	localKeys[1] = keys.toString();
	this.webElement.sendKeys(localKeys);
  } 
    
  function submit() {
    this.webElement.submit();
  }  
  
  function getText() {
    return this.webElement.getText();
  } //}java.lang.String 
  
  function clear() {
    this.webElement.clear();
  } //}void 
	
	
	function click() {
	    this.webElement.click();
	} //}void 
	
	
	function toggle() {
	 return this.webElement.toggle();
	} //boolean 
	
	
	function setSelected() {
	  this.webElement.setSelected();
	} //}void
	
	
	function isEnabled() {
	  return this.webElement.isEnabled();
	} //}boolean
	
	 
	function isSelected() {
	 return this.webElement.isSelected();
	} //}boolean 
	
	//To Do ---------------------------------------
	function dragAndDropBy(x,y){} //}(int, int) void 
	function dragAndDropOn(renderedElement){} //}(org.openqa.selenium.RenderedWebElement) void 
	function findElement(by){} //}(org.openqa.selenium.By) org.openqa.selenium.WebElement 
	function findElements(by){} //}(org.openqa.selenium.By) java.util.List 
	function getAttribute(name){} //}(java.lang.String) java.lang.String 
	function getChildrenOfType(strElement){} //}(java.lang.String) java.util.List 
	function getLocation() {} //}ava.awt.Point 
	function getSize() {} //}java.awt.Dimension 
	function getValue() {} //}java.lang.String 
	function getValueOfCssProperty(css){} //}(java.lang.String) java.lang.String 
	function isDisplayed() {} //}boolean 
	
	
	
	
  

</cfscript>
</cfcomponent>


