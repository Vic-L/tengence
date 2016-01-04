var PaginationLink = React.createClass({
  handleClick: function(e){
    e.preventDefault();
    this.props.getTenders(e.target.href, document.getElementById('query-field').value);
  },
  render: function(){
    if (this.props.path != null){
      if (this.props.currentPage != null) {
        return <span>{this.props.children}</span>
      } else {
        return <a href={this.props.path + '?page=' + this.props.page} onClick={this.handleClick}>{this.props.children}</a>
      }
    } else {
      return <span>{this.props.children}</span>
    }
  }
})