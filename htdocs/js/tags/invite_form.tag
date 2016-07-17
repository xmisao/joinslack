<invite_form>
  <invite_form_input if={ state == 'input' } />  
  <invite_form_sending if={ state == 'sending' } />  
  <invite_form_succeeded if={ state == 'succeeded' } />  
  <invite_form_failed if={ state == 'failed' } />  

  this.state = 'input';

  this.change_state = function(state) {
    this.state = state;
    this.update();
  }
</invite_form>

<invite_form_input>
  <form>
    <div class="form-group">
      <label for="email">Email address:</label>
      <input type="email" name="email" id="email" class="form-control" placeholder="Email">
    </div>
    <button class="btn btn-default" onclick="{send_invite}">Send invite</button>
  </form>

  parent = this.parent;

  this.send_invite = function(e) {
    parent.change_state('sending');
    $.post(
      './invite',
      {email: this.email.value},
      function(data, textStatus, jqxhr){
        if (data['succeeded']) {
          parent.change_state('succeeded');
        } else {
          parent.change_state('failed');
        }
      },
      'json');
  }
</invite_form_input>

<invite_form_sending>
  <div class="progress">
    <div class="progress-bar progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">
      Sending...
    </div>
  </div>

  var parent = this.parent;
</invite_form_sending>

<invite_form_succeeded>
  <div class="alert alert-success" role="alert">
    <p>Invitation is succeeded! Please check your inbox and join us.</p>
  </div>
</invite_form_succeeded>

<invite_form_failed>
  <div class="alert alert-danger" role="alert">
    <p>Invitation is failed. Sorry, something wrong!</p>
  </div>
</invite_form_failed>
