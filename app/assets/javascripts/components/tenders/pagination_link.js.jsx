var PaginationLink = React.createClass({
  handleClick: function(e){
    e.preventDefault();
    $('#select_all').prop('checked', false);
    var urlFragments = Tengence.ReactFunctions.dissectUrl(this.props.url);
    this.props.getTenders(urlFragments.path, this.props.page, urlFragments.table, urlFragments.query, urlFragments.keywords, urlFragments.sortOrder);
  },
  render: function(){
    if (this.props.url != null){
      if (this.props.currentPage != null) {
        return <span>{this.props.children}</span>
      } else {
        return <a href='' onClick={this.handleClick}>{this.props.children}</a>
      }
    } else {
      return <span>{this.props.children}</span>
    }
  }
})