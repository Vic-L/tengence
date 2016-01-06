var WatchedTendersTableHeader = React.createClass({
  handleCheck: function(e){
    if (e.target.checked) {
      $("input[name^='select_single[]']").prop('checked', true);
    } else {
      $("input[name^='select_single[]']").prop('checked', false);
    }
  },
  handleClick: function(e){
    e.preventDefault();
    if (confirm('Delete all checked tenders from your watchlist. Are you sure?')) {
      var selected = [];
      $("input[name^='select_single[]']").each(function(){
        if (this.checked) {
          selected.push($(this).attr('value'));
        }
      });
      this.props.massDestroyTenders(selected);
    }
  },
  render: function() {
    return (
      <thead>
        <tr>
          <th className="medium-1">
            <input id="select_all" name="select_all" type="checkbox" value="1" onClick={this.handleCheck} />
            <a id="destroy-all-button" href='' onClick={this.handleClick}>
              <i className="fa fa-trash icon"></i>
            </a>
          </th>
          <th className='medium-1'>Status</th>
          <th className='medium-4'>Description</th>
          <th className='medium-1'>Published Date</th>
          <th className='medium-1'>Closing Date</th>
          <th className='medium-1'>Closing Time</th>
          <th className='medium-1'>Buyer Entity</th>
          <th className='medium-1'>Watchlist</th>
          <th className='medium-1'>Details</th>
        </tr>
      </thead>
    );
  }
});