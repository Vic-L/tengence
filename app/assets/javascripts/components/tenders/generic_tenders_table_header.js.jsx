var GenericTendersTableHeader = React.createClass({
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
    if (Tengence.ReactFunctions.isPostedTendersPage()) {
      return (
        <thead>
          <tr>
            <th className='medium-6'>Description</th>
            <th className='medium-1 hide-for-small'>Published Date</th>
            <th className='medium-2'>Closing Date</th>
            <th className='medium-1 hide-for-small'>Closing Time</th>
            <th className='medium-1 hide-for-small'>Edit</th>
            <th className='medium-1'>Details</th>
          </tr>
        </thead>
      );
    } else {
      if (Tengence.ReactFunctions.finished_trial_but_yet_to_subscribe(this.props.trial_tenders_count)){
        if (Tengence.ReactFunctions.isWatchedTendersPage()) {
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
                <th className='medium-5'>Description</th>
                <th className='medium-1'>Published Date</th>
                <th className='medium-1'>Closing Date</th>
                <th className='medium-1'>Closing Time</th>
                <th className='medium-1'>Watchlist</th>
                <th className='medium-1'>Details</th>
              </tr>
            </thead>
          );
        } else {
          return (
            <thead>
              <tr>
                <th className='medium-6'>Description</th>
                <th className='medium-2 hide-for-small'>Published Date</th>
                <th className='medium-1'>Closing Date</th>
                <th className='medium-1 hide-for-small'>Closing Time</th>
                <th className='medium-1 hide-for-small'>Watchlist</th>
                <th className='medium-1'>Details</th>
              </tr>
            </thead>
          );
        }
      } else {
        if (Tengence.ReactFunctions.isWatchedTendersPage()) {
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
        } else {
          return (
            <thead>
              <tr>
                <th className='medium-5'>Description</th>
                <th className='medium-1 hide-for-small'>Published Date</th>
                <th className='medium-1'>Closing Date</th>
                <th className='medium-1 hide-for-small'>Closing Time</th>
                <th className='medium-1'>Buyer Entity</th>
                <th className='medium-1 hide-for-small'>Watchlist</th>
                <th className='medium-1'>Details</th>
              </tr>
            </thead>
          );
        }
      }
    }
  }
});