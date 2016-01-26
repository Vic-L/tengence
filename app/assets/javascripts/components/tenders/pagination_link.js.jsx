var PaginationLink = React.createClass({
  handleClick: function(e){
    e.preventDefault();
    $('#select_all').prop('checked', false);
    var link = new URI(this.props.path);
    link.removeQuery('page');
    link.addQuery('page',this.props.page);
    var searchField = document.getElementById('query-field');
    var sort = $('.sort')[0];
    if (searchField != null && searchField.value != '') {
      this.props.getTenders(link.toString(), searchField.value, null, sort.value);
    } else {
      this.props.getTenders(link.toString(), null, null, sort.value);
    }
  },
  render: function(){
    if (this.props.path != null){
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