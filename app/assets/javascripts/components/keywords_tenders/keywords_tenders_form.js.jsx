var KeywordsTendersForm = React.createClass({
  handleClick: function(e){
    e.preventDefault();
    var keywords = document.getElementById('keywords').value;
    this.props.updateKeywords(keywords);
  },
  render: function() {
    var notice;
    if (this.props.keywords != null){
      if (this.props.keywords.trim().length === 0) {
        notice = <p className='text-center no-keywords-notice'>You have no keywords. Start adding up to 20 keywords and get emails everyday on new tenders related to your set of keywords.</p>;
      } else if (this.props.keywords.split(',').length > 20) {
        notice = <p className='text-center'>Too many keywords. Only 20 keywords are allowed.</p>;
      } else {
      }
    }
    return (
      <div className='row'>
        {notice}
        <div className="small-8 columns small-centered text-center">
          <span>Your keywords:</span>
          <textarea id=' keywords' rows='3' name="keywords" id="keywords" placeholder="Enter up to 20 keywords separated by commas, eg. jurong,maintenance, event" defaultValue={this.props.keywords}>
          </textarea>
          <button id='submit' onClick={this.handleClick}>UPDATE</button>
        </div>
      </div>
    );
  }
});
