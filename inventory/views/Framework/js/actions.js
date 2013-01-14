	/* author: Matthew Darby
	 * date: 08/03/2006
	 * file: actions.js
	 */
	var myrules = {
		'input.linkbutton' : function(el){
			el.onclick = function(){
				document.location.href = el.getAttribute('link');
			}
		},		
		'input.deletebutton': function(el){
			el.onclick = function(){
				var con = confirm(el.getAttribute('message'));
				if (con){
					el.form.action.value = 'DELETE';
					return true;
				}
				return false;
			}
		},
		'select.populate': function(el) {
			el.onchange = function() {
				recursiveSelect_request(this,this.form.genre,'getGenreAndBinding');			
			}
		}
	};
	
	Behaviour.register(myrules);