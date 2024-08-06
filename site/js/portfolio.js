var GitHubAPI = {};

GitHubAPI.Repo = function(username, reponame, callback) {
  requestURL = "https://api.github.com/repos/"+username+"/"+reponame+'';
  var request = new XMLHttpRequest();
  request.responseType = 'json';
  request.onload = callback;
  request.open('GET', requestURL, true);
  request.onload  = function() {
    callback(request.response);
  };
  request.send();
};

(function() {
  GitHubAPI.Repo('jverkoey', 'nimbus', function(response) {
    document.getElementById('nimbus_forks').innerHTML = response.forks + ' forks';
    document.getElementById('nimbus_followers').innerHTML = response.watchers + ' followers';
  });
})();
