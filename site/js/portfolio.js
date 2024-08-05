var GitHubAPI = {};

GitHubAPI.Repo = function(username, reponame, callback) {
  requestURL = "https://api.github.com/repos/"+username+"/"+reponame+'?callback=?';
  $.getJSON(requestURL, function(json, status){
    callback(json, status);
  });
};

$(document).ready(function(){
  GitHubAPI.Repo('jverkoey', 'nimbus', function(json, status) {
    if (json.meta.status == 200) {
      $('#nimbus_forks').html(json.data.forks+' forks');
      $('#nimbus_followers').html(json.data.watchers+' followers');
    }
  });
});