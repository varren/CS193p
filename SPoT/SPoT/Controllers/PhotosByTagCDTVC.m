//
//  PhotosCDTVC.m
//  SPoT
//
//  Created by mmh on 22/01/2014.
//  Copyright (c) 2014 mmh. All rights reserved.
//

#import "PhotosByTagCDTVC.h"
@interface PhotosCDTVC()<UISearchBarDelegate, UISearchDisplayDelegate>
@property (weak,nonatomic) IBOutlet UISearchBar * searchBar;

@end
@implementation PhotosByTagCDTVC

-(void)setTag:(Tag*)tag{
    _tag = tag;
    self.title = tag.name;
    [self setupFetchResultsController];
}
@synthesize searchBar = _searchBar;
-(void)viewDidLoad{
    [super viewDidLoad];
    self.searchBar.delegate = self;
    self.tableView.contentOffset = CGPointMake(0.0, self.searchBar.frame.size.height); //to hide search bar by default
    
}

-(void) setupFetchResultsController{
     [self filteredRequestWithSearchText:nil];
}

-(void) filteredRequestWithSearchText:(NSString*) searchText{
    if(self.tag.managedObjectContext){
        NSString * sectionKey = (self.tag.name == [Tag allTag]) ? @"mainTag" : @"sectionName" ;
        NSString * descriptorKey = (self.tag.name == [Tag allTag]) ? @"mainTag" : @"title";
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:descriptorKey ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        
        request.predicate = [NSPredicate predicateWithFormat:@"ANY tags == %@", self.tag, searchText];
        
        if(searchText && ![searchText isEqual: @""]){
            NSPredicate * searchCondition = [NSPredicate predicateWithFormat:@" title contains[cd] %@", searchText];
            request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[request.predicate, searchCondition]];
        }
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.tag.managedObjectContext sectionNameKeyPath:sectionKey cacheName:nil];
    }else{
        self.fetchedResultsController = nil;
    }

}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self filteredRequestWithSearchText:searchText];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
-(NSArray*) sectionIndexTitlesForTableView:(UITableView *)tableView{
        return nil;
}
@end
