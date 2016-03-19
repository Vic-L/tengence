var KeywordsTendersForm = React.createClass({
  handleClick: function(e){
    e.preventDefault();
    var urlFragments = Tengence.ReactFunctions.dissectUrl(this.props.url);
    var keywords = document.getElementById('keywords').value;
    this.props.updateKeywords(keywords, urlFragments);
  },
  submitKeywords: function(e) {
    if(e.keyCode === 13){
      e.preventDefault();
      if (!$('body').hasClass('loading')){
        var urlFragments = Tengence.ReactFunctions.dissectUrl(this.props.url);
        var keywords = document.getElementById('keywords').value;
        this.props.updateKeywords(keywords, urlFragments);
      }
    }
  },
  render: function() {
    var notice;
    if (this.props.keywords != null){
      if (this.props.keywords.trim().length === 0) {
        notice = <p className='text-center keywords-error-notice'>You have no keywords. Start adding up to 20 keywords and get emails everyday on new tenders related to your set of keywords.</p>;
      } else if (this.props.keywords.split(',').length > 20) {
        notice = <p className='text-center keywords-error-notice'>Too many keywords. Only 20 keywords are allowed.</p>;
      } else {
      }
    } else {
      notice = <p className='text-center keywords-error-notice'>You have no keywords. Start adding up to 20 keywords and get emails everyday on new tenders related to your set of keywords.</p>;
    }
    return (
      <div className='row'>
        <div className="small-8 columns small-centered text-center">
          <span>Your keywords (Note: separate keywords with comma)</span>
          <textarea id=' keywords' rows='3' name="keywords" id="keywords" placeholder="Enter up to 20 keywords separated by commas, eg. jurong,maintenance, event" defaultValue={this.props.keywords} onKeyDown={this.submitKeywords}>
          </textarea>
          {notice}
          <button id='submit' onClick={this.handleClick}>UPDATE</button>
        </div>
      </div>
    );
  }
});
