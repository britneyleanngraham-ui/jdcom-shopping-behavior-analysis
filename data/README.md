# Data

This project uses the JDsearch dataset, a public JD.com search and shopping behavior dataset.

The processed analytical dataset used in this project contains:

- 320,132 recorded positive interactions
- 223,909 clicks
- 75,407 add-to-cart interactions
- 20,816 purchases
- 110,393 unique query records
- 237,814 unique products
- 47,757 unique brands
- 4,777 product categories

## Scope

The processed dataset includes only positive interaction labels:

- 1 = Click
- 2 = Add to Cart
- 3 = Purchase

Non-interaction records are not included in the analytical dataset.

Because the source data does not contain linked customer sessions or complete customer journeys, the analysis uses **Purchase Share** rather than a traditional conversion rate.

**Purchase Share = Purchases / Recorded Positive Interactions**

## Data Quality Notes

The cleaned dataset contains 16,575 exact duplicate rows.

These records were retained because the source data does not include timestamps or a unique event-level identifier, so identical rows cannot conclusively be classified as accidental duplicates.

A sensitivity analysis was performed using a deduplicated version of the dataset. Overall Purchase Share changed only from approximately 6.50% to 6.63%, indicating that the duplicate assumption did not materially change the headline interpretation.

The dataset also contains 1,776 records with `shop_id = -1`, representing unidentified shops. These records are retained in the overall analysis but excluded from shop-level performance comparisons.

## Data Availability

The full source and processed datasets are not stored in this repository.

The repository includes the final analytical output tables used for reporting and visualization in the `/outputs` folder.
