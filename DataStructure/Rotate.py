def count_rotations_binary(nums):
    N = len(nums)
    lo = 0
    hi = N-1
   
    while lo < N:
        mid = (lo+hi)//2
        mid_number = nums[mid]
        
        # Uncomment the next line for logging the values and fixing errors.
        #print("lo:", lo, ", hi:", hi, ", mid:", mid, ", mid_number:", mid_number)
        
        if mid > lo and mid_number < nums[mid-1]:
            # The middle position is the answer
            return mid
        
        elif mid_number < nums[lo]:
            # Answer lies in the left half
            hi = mid - 1  
        
        else:
            # Answer lies in the right half
            lo = mid + 1
            
        
    
    return -1

if __name__ == "__main__" :

    num = [19, 25, 29, 3, 5, 6, 7, 9, 11]
    print(count_rotations_binary(num))