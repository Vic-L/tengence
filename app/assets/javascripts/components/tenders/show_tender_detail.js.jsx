var ShowTenderDetail = React.createClass({
  rawMarkup: function() {
    // console.log(this.props.body);
    var rawMarkup = marked(this.props.body.toString(), {sanitize: false});
    return { __html: this.props.body };
  },
  render: function(){
    return (
      <div className='row'>
        <div className='small-12 column'>
          <div className='header'>
            {this.props.header}
          </div>
        </div>
        <div className='small-12 column'>
          <div className={this.props.extraClass} dangerouslySetInnerHTML={this.rawMarkup()}></div>
        </div>
      </div>
    )
  }
});